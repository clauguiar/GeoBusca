#!/bin/bash
#----------------------------------------------
# Watch for changes BaseGeo script.
#----------------------------------------------
# Delete files script.
#----------------------------------------------
# Author Claudia Enk de Aguiar
#----------------------------------------------

source /BaseGeo/aplicativos/django_projects/geobusca01_acre_site/geobusca01_acre_app/scripts/00_wait_changes_variables_source.sh

path=${1};
file=${2};

echo  -n "O arquivo ${file} na localização ${path} precisa ser removido em "; date;
script_name=`basename "$0" .sh`; 
echo "Script ${script_name}"; 
echo
echo "DELETE FROM ${raster_index} WHERE location like '""${path}${file}""' || '%';" | psql -w -h "${postgresql_host}" -p 5432 -d "${database}" -U geoadmin; 

