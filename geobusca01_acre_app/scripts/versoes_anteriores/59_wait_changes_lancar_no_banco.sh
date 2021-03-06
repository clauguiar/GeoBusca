#!/bin/bash
#----------------------------------------------
# Watch for changes BaseGeo script.
#----------------------------------------------
# Search for files in a directory script.
#----------------------------------------------
# Author Claudia Enk de Aguiar
#----------------------------------------------

source /BaseGeo/aplicativos/django_projects/geobusca01_acre_site/geobusca01_acre_app/scripts/00_wait_changes_variables_source.sh

epsg=${1};

echo -n "LANÇANDO ARQUIVOS SHAPE COM EPSG ${epsg} PARA O BANCO EM "; date;
script_name=`basename "$0" .sh`; 
echo "Script ${script_name}"; 

shp2pgsql -a -I -s "${epsg}" tmp.shp "${raster_index}" | psql -w -h "${postgresql_host}" -p 5432 -d "${database}" -U geoadmin; 