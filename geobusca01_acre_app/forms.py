import datetime
import re

from django.utils import timezone
from django.forms import ModelForm

#from django.contrib.gis import forms
from django.contrib.gis.geos import Point, GeometryCollection, GEOSGeometry
from django.forms.widgets import SelectDateWidget, CheckboxSelectMultiple
from django.utils.translation import gettext_lazy as _
import floppyforms.__future__ as forms

from .models import Ponto, Chave, Missao, Satelite

class DatePicker(forms.DateInput):
    template_name = 'geobusca01_acre_app/datepicker.html'

    class Media:
        js = (
            'js/jquery.min.js',
            'js/jquery-ui.min.js',
        )
        css = {
            'all': (
                'css/jquery-ui.css',
            )
        }

class PointWidget(forms.gis.GeometryCollectionWidget, forms.gis.BaseGMapWidget):
	google_maps_api_key = 'AIzaSyBeGJoYiqjs9Y_U3FXdip0YooxFmRdKnFo'
	#https://stackoverflow.com/questions/10997235/django-floppyforms-basegmapwidget-default-zoom-and-lat-long
	template_name = 'geobusca01_acre_app/custom_lonlat.html'
	default_lon = -54
	default_lat = -30.397
	default_zoom = 6
	
	def get_context_data(self):
		ctx = super(PointWidget, self).get_context_data()
		ctx.update({
			'lon': self.default_lon,
			'lat': self.default_lat,
			'zoom': self.default_zoom,
		})
		return ctx

class PontoForm(forms.ModelForm):
	class Meta:
		model = Ponto
		fields = ['coll', 'req_min_date', 'req_max_date', 'missoes', 'satelites']
	coll = forms.gis.GeometryCollectionField(required=False, widget=PointWidget, label='')
	req_min_date = forms.DateField(required=False, widget=forms.DateInput(attrs={'format':'DD-MM-YYYY', 'type':'datepicker'}), label='Data mínima desejada')
	#req_max_date = forms.DateField(required=False, widget=SelectDateWidget(years=range(1971, 2019)), label='Data máxima desejada')
	req_max_date = forms.DateField(required=False, widget=forms.DateInput(attrs={'format':'DD-MM-YYYY', 'type':'datepicker'}), label='Data máxima desejada')
	missoes = forms.ModelMultipleChoiceField(
		queryset = Missao.objects.all(), 
		widget = forms.CheckboxSelectMultiple,
		required=False,
		label='Missão'
	)
	satelites = forms.ModelMultipleChoiceField(
		queryset = Satelite.objects.all(), 
		widget = forms.CheckboxSelectMultiple,
		required=False,
		label='Satélite'
	)
	#chaves = forms.ModelMultipleChoiceField(
		#queryset = Chave.objects.all(), 
		#widget = forms.CheckboxSelectMultiple,
		#required=False,
		#label='Filtro'
	#)
    	
	def clean_req_date(self):
		cleaned_data = super(PontoForm, self).clean()
		req_min_date = cleaned_data.get("req_min_date")
		req_max_date = cleaned_data.get("req_max_date")
		
		if req_min_date and req_max_date:
			if req_max_date < req_min_date:
				raise forms.ValidationError("A data máxima não pode ser menor que a data mínima.")
		return cleaned_data

