import datetime

from django.contrib.gis.db import models
from django.contrib.gis.geos import *
from django.utils import timezone
from django.core.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _
from django.core.validators import MaxValueValidator, MinValueValidator
from django.core.files.storage import FileSystemStorage
#from olwidget.widgets import MapDisplay

fs = FileSystemStorage(location='media/')

class Etiqueta(models.Model):
	nome = models.CharField(max_length=50, unique=True)
	
	class Meta:
		verbose_name, verbose_name_plural = "Etiqueta para Imagens de Satélite" , "Etiquetas para Imagens de Satélite"
		ordering = ('nome',)
		
	def __str__(self):
		return "%s" % self.nome
		
class Chave(models.Model):
	nome = models.CharField(max_length=50, unique=True)
	etiquetas = models.ManyToManyField(Etiqueta)
	
	class Meta:
		verbose_name, verbose_name_plural = "Chave para Imagens de Satélite" , "Chaves para Imagens de Satélite"
		ordering = ('nome',)
		
	def __str__(self):
		return "%s" % self.nome

class Missao(models.Model):
	nome = models.CharField(max_length=50, unique=True)
	
	class Meta:
		verbose_name, verbose_name_plural = "Missão para Observação da Terra" , "Missões para Observação da Terra"
		ordering = ('nome',)
		
	def __str__(self):
		return "%s" % self.nome
		
class Satelite(models.Model):
	nome = models.CharField(max_length=50, unique=True)
	missao = models.ForeignKey(Missao, on_delete=models.CASCADE)
	
	class Meta:
		verbose_name, verbose_name_plural = "Satélite" , "Satélites"
		ordering = ('nome',)
		
	def __str__(self):
		return "%s" % self.nome



class Ponto(models.Model):
	gid = models.AutoField(primary_key=True)
	point = models.PointField('Selecionar ponto', srid=4674, blank=True, null=True)
	poly = models.PolygonField('Selecionar polígono', srid=4674, blank=True, null=True)
	coll = models.GeometryCollectionField('Selecionar local/is', srid=4674, blank=True, null=True)
	query_date = models.DateTimeField('Data da consulta', auto_now_add=True)
	req_min_date = models.DateField('Data mínima desejada', blank=True, null=True)
	req_max_date = models.DateField('Data máxima desejada', blank=True, null=True)
	missoes = models.ManyToManyField(Missao, blank=True)
	satelites = models.ManyToManyField(Satelite, blank=True)
	chaves = models.ManyToManyField(Chave, blank=True)
	
	
	class Meta:
		verbose_name, verbose_name_plural = "Ponto em Sirgas 2000" , "Pontos em Sirgas 2000"
		ordering = ('query_date',)
		
	def __str__(self):
		return "%s" % self.gid
		
	def periodo_positivo(self):
		return self.req_min_date > self.req_max_date
		
	def display_coll(self):
		map = MapDisplay(fields=[Ponto.coll])
		return "%s" % self.map
		

class Raster(models.Model):
	gid = models.AutoField(primary_key=True)
	acq_date = models.DateField('Data de aquisição', null=True)
	acq_year = models.IntegerField('Ano de aquisição', null=True)
	location = models.FileField('Endereço do arquivo', max_length=254)
	src_srs = models.CharField('EPSG original', max_length=254, null=True) # Necessário para as imagens Digital Globe
	satelite = models.ForeignKey(Satelite, on_delete=models.CASCADE, blank=True, null=True)
	geom = models.MultiPolygonField(srid=4674)
	
	class Meta:
		verbose_name, verbose_name_plural = "Polígono de Rasters em Sirgas 2000" , "Polígonos de Rasters em Sirgas 2000"
		ordering = ('location',)
		
	def __str__(self):
		return "%s" % self.location
		
