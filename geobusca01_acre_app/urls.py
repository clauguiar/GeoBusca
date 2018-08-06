from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from django.urls import include, re_path

from . import views

app_name = 'geobusca01_acre_app'
urlpatterns = [
    # Geobusca Protótipo /geobusca01_acre_app/
    path('', views.index, name='index'),
    # Busca por ponto ex. /geobusca01_acre_app/busca
    path('busca/', views.busca, name='busca'),
    # Resultado por ponto ex. geobusca01_acre_app/5/resultado
    path('<int:ponto_gid>/resultado/', views.resultado, name='resultado'),
    # Histórico de buscas ex. geobusca01_acre_app/historico
    path('historico', views.historico, name='historico'),
    # Render map template ex. geobusca01_acre_app/map_view
    path('map_view', views.map_view, name='map_view'),
    # Download de rasters ex. geobusca01_acre_app/6/arquivo
    path('<int:raster_gid>/arquivo/', views.arquivo, name='arquivo'),
    
]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
