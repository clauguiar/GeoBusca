#!/bin/bash
#----------------------------------------------
# Watch for changes BaseGeo application.
#----------------------------------------------
# Variables source script.
#----------------------------------------------
# Author Claudia Enk de Aguiar
#----------------------------------------------

#---- variables -------------------------------

version="geobusca01_acre"; 

find_dir="/BaseGeo/arquivos/"; 
geoadmin_pass="/home/geoadmin/.pgpass"; 
logrotate_file="/etc/logrotate.d/geobusca"; 
me="Wait changes"; 
postgresql_host="localhost";
root_pass="/root/.pgpass"; 

	database="${version}_db"; 
	log_dir="/var/log/geobusca/${version}/"; 
	raster_index="${version}_app_raster"; 
	search_dir="GEODADOS/"; 
	site_dir="/BaseGeo/aplicativos/django_projects/${version}_site/"; 
	wait_dir="${find_dir}${search_dir}";

		script_dir="${site_dir}${version}_app/scripts/"; 
		shp_dir="${site_dir}media/"; 

			epsg_exig_file="${script_dir}epsg_files_exigent.csv"; 

#---- arrays ----------------------------------

compressed=("zip" "tar.bz" "tar" "tar.gz"); 
inflate_and_extract=("unzip -u" "tar xf"); 
extensions=(tif img tiff); 

