# coding: utf-8
from django import forms
from django.contrib.gis import admin
from .models import *

# Módulo de busca administrativo

admin.site.register(Chave, admin.OSMGeoAdmin)

admin.site.register(Etiqueta, admin.OSMGeoAdmin)

admin.site.register(Raster, admin.OSMGeoAdmin)

admin.site.register(Satelite, admin.OSMGeoAdmin)

admin.site.register(Missao, admin.OSMGeoAdmin)
