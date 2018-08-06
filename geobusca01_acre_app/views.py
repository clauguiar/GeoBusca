import os

from datetime import datetime

from django.conf import settings
from django.http import HttpResponseRedirect, HttpResponse
from django.shortcuts import get_object_or_404, render, render_to_response
from django.urls import reverse
from django.views import generic
from django.contrib.gis.geos import *
from django.db.models import Q
from django.db.models import OuterRef, Subquery
from wsgiref.util import FileWrapper
from django.contrib.gis.gdal import SpatialReference, CoordTransform
from django.db.models import Max, Min
from django.core import serializers

from geobusca01_acre_site.settings import MEDIA_ROOT
from .models import Ponto, Raster, Chave, Etiqueta, Missao, Satelite
from .forms import PontoForm

def index(request):
	latest_ponto_list = Ponto.objects.order_by('-query_date')[:5]
	context = {'latest_ponto_list': latest_ponto_list}
	return render(request, 'geobusca01_acre_app/index.html', context)

def busca(request):
	if request.method == 'POST':
		form = PontoForm(request.POST)
		if form.is_valid():
			form.save()
			ponto_gid = Ponto.objects.latest('gid')
			return HttpResponseRedirect(reverse('geobusca01_acre_app:resultado', args=(ponto_gid,)))
	else:
		form = PontoForm()
	return render(request, 'geobusca01_acre_app/busca.html', {'form': form})

# Filter Django database for field containing any value in an array
# https://stackoverflow.com/questions/8949145/filter-django-database-for-field-containing-any-value-in-an-array
# https://gis.stackexchange.com/questions/108521/geodjango-trying-to-get-points-within-a-polygon
def resultado(request, ponto_gid):
	ponto = get_object_or_404(Ponto, pk=ponto_gid)
	# Criando o objeto de consulta QUERYSET
	rasters_contem_ponto = Raster.objects.all()
	# Filtrando por DATAS MÍNIMA E MÁXIMA:
	#format = '%Y-%m-%d'
	# https://stackoverflow.com/questions/11425802/how-to-check-that-the-data-is-null-in-django-view
	# is None used for == null and is not None used for !=null
	raster_date_range = Raster.objects.exclude(acq_date__isnull=True).aggregate(min_date=Min('acq_date'), max_date=Max('acq_date'))
	if ponto.req_min_date is not None:
		ponto_min_date = ponto.req_min_date
	else:
		ponto_min_date = raster_date_range['min_date']
	if ponto.req_max_date is not None:
		ponto_max_date = ponto.req_max_date
	else:
		ponto_max_date = raster_date_range['max_date']
	ponto_min_year = ponto_min_date.year
	ponto_max_year = ponto_max_date.year
	date_query = Q(acq_date__range=[ponto_min_date, ponto_max_date])|(Q(acq_date=None)&Q(acq_year__range=[ponto_min_year, ponto_max_year])|Q(acq_year=None))
	# Adicionando o filtro por PERÍODO ao queryset
	rasters_contem_ponto = rasters_contem_ponto.filter(date_query)
	# Filtrando por ETIQUETAS:
	# https://docs.djangoproject.com/en/2.0/topics/db/queries/#lookups-that-span-relationships
	# To span a relationship, just use the field name of related fields across models,
	# separated by double underscores, until you get to the field you want.
	# https://stackoverflow.com/questions/14920735/manyrelatedmanager-object-is-not-iterable
	etiquetas = Etiqueta.objects.filter(chave__ponto__gid=ponto_gid)
	# http://blog.etianen.com/blog/2013/06/08/django-querysets/
	if etiquetas.exists():
		# https://stackoverflow.com/questions/4424435/how-to-convert-a-django-queryset-to-a-list
		values = list(etiquetas)
		# https://docs.python.org/3/howto/regex.html
		# https://stackoverflow.com/questions/852414/how-to-dynamically-compose-an-or-query-filter-in-django
		# Turn list of values into list of Q objects
		# https://micropyramid.com/blog/querying-with-django-q-objects/
		# Q objects are helpfull for complex queries because they can be combined using logical operators:
		# and(&), or(|), negation(~)
		# https://stackoverflow.com/questions/18140838/sql-like-equivalent-in-django-query
		# contains and icontains mentioned by falsetrue make queries like SELECT ... WHERE headline LIKE '%pattern%
		# Along with them, you might need these ones with similar behavior: startswith, istartswith, endswith, iendswith
		queries = [Q(location__icontains=value) for value in values]
		# Take one Q object from the list
		query = queries.pop()
		# Or the Q object with the ones remaining in the list
		for item in queries:
			query |= item
		# Adicionando o filtro por PERÍODO ao queryset
		rasters_contem_ponto = rasters_contem_ponto.filter(query)
	# Filtrando por MISSÕES:
	missoes = Missao.objects.filter(ponto__gid=ponto_gid)
	if missoes.exists():
		miss_values = list(missoes)
		miss_queries = [Q(satelite__missao=miss_value) for miss_value in miss_values]
		miss_query = miss_queries.pop()
		for miss_item in miss_queries:
			miss_query |= miss_item
		rasters_contem_ponto = rasters_contem_ponto.filter(miss_query)
	# Filtrando por SATÉLITES:
	satelites = Satelite.objects.filter(ponto__gid=ponto_gid)
	if satelites.exists():
		sat_values = list(satelites)
		sat_queries = [Q(satelite=sat_value) for sat_value in sat_values]
		sat_query = sat_queries.pop()
		for sat_item in sat_queries:
			sat_query |= sat_item
			rasters_contem_ponto = rasters_contem_ponto.filter(sat_query)
	# Filtrando por ELEMENTO GEOGRÁFICO:
	if ponto.coll is not None:
		cl = ponto.coll
		geom_queries = [Q(geom__intersects=cl_geom) for cl_geom in cl]
		geom_query = geom_queries.pop()
		for geom_item in geom_queries:
			#https://djangosnippets.org/snippets/2420/
			if (geom_item.dims) == 0:
				pt = cl_geom
			if (geom_item.dims) == 1:
				ln = cl_geom
			if (geom_item.dims) == 2:
				py = cl_geom
			if pt:
				geom_query |= MultiPoint(pt, srid=cl_srid)
			if ln:
				geom_query |= MultiLineString(ln, srid=cl_srid)
			if py:
				geom_query |= MultiPolygon(py, srid=cl_srid)
		rasters_contem_ponto = rasters_contem_ponto.filter(geom_query)
	# Ordenando a lista por satélite, data e locação:
	rasters_contem_ponto = rasters_contem_ponto.order_by('satelite', 'acq_date', 'location')
	context = {'rasters_contem_ponto': rasters_contem_ponto}
	return render(request, 'geobusca01_acre_app/resultado.html', context)

def arquivo(request, raster_gid):
	# https://stackoverflow.com/questions/908258/generating-file-to-download-with-django
	raster = get_object_or_404(Raster, gid=raster_gid)
	file_path =  os.path.join(MEDIA_ROOT, raster.location.path)
	# https://www.pythonanywhere.com/forums/topic/1354/
	# https://stackoverflow.com/questions/36392510/django-download-a-file
	if os.path.exists(file_path):
		with open(file_path, 'rb') as fh:
			response = HttpResponse(fh.read(), content_type="image/tif")
			response['Content-Disposition'] = 'inline; filename=' + os.path.basename(file_path)
			return response
	raise Http404

def historico(request):
	points = Ponto.objects.kml()
	return render_to_kml("geobusca01_acre_app/placemarks.kml", {'places':points})

# renders map template
def map_view(request):
  return render_to_response("geobusca01_acre_app/map_view.html")
