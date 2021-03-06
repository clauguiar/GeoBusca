#!/bin/bash
#----------------------------------------------
# Watch for changes BaseGeo application.
#----------------------------------------------
# Gdal to index script.
#----------------------------------------------
# Author Claudia Enk de Aguiar
#----------------------------------------------

source /BaseGeo/aplicativos/django_projects/geobusca01_acre_site/geobusca01_acre_app/scripts/00_wait_changes_variables_source.sh
script_name=`basename "$0" .sh`; 

image_file="$1";

#---- gdal to index ---------------------------

substr3="${image_file#*/}"; 
substr1="${substr3#*/}";
substr1="${substr2#*/}"; 
lyr_name="${substr1%%/*}"; 
echo "O nome da camada é ${lyr_name}"; 
nome=`basename "${image_file}"`; 
echo "O nome do arquivo é ${nome}"; 
if grep -q -e "$nome" "${epsg_exig_file}"; then 
	epsg_orig=$(grep -e "$nome" "${epsg_exig_file}" | cut -d "," -f 1); 
else 
	epsg_orig="nenhum"; 
fi; 
echo "O epsg a ser usado é ${epsg_orig}"; 
gdaltindex -t_srs EPSG:4674 -lyr_name "${lyr_name}" ${shp_dir}${epsg_orig}_tmp.shp "${image_file}";
