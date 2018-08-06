#!/bin/bash
#----------------------------------------------
# Watch for changes BaseGeo script.
#----------------------------------------------
# Insert dates script.
#----------------------------------------------
# Author Claudia Enk de Aguiar
#----------------------------------------------

source /BaseGeo/aplicativos/django_projects/geobusca01_acre_site/geobusca01_acre_app/scripts/00_wait_changes_variables_source.sh

echo "Inserindo os shapes de rasters na tabela ${raster_index} do banco de dados ${database} no servidor ${postgresql_host}";
script_name=`basename "$0" .sh`; 
echo "Script ${script_name}"; 
echo

shp2pgsql -a -I -s 4674  nenhum_tmp.shp "${raster_index}" | psql -w -h "${postgresql_host}" -p 5432 -d "${database}" -U geoadmin;  
shp2pgsql -a -I -s 32722:4674 32722_tmp.shp "${raster_index}" | psql -w -h "${postgresql_host}" -p 5432 -d "${database}" -U geoadmin; 
shp2pgsql -a -I -s 32721:4674 32721_tmp.shp "${raster_index}"| psql -w -h "${postgresql_host}" -p 5432 -d "${database}" -U geoadmin; 

