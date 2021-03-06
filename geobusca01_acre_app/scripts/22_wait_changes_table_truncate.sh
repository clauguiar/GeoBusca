#!/bin/bash
#----------------------------------------------
# Watch for changes BaseGeo application.
#----------------------------------------------
# Initial truncate table script.
#----------------------------------------------
# Author Claudia Enk de Aguiar
#----------------------------------------------

source /BaseGeo/aplicativos/django_projects/geobusca01_acre_site/geobusca01_acre_app/scripts/00_wait_changes_variables_source.sh

echo -n "INICIANDO ESVAZIAMENTO DA TABELA ${raster_index} de ${database} em ${postgresql_host} EM "; date; 
script_name=`basename "$0" .sh`; 
echo "Script ${script_name}"; 
echo; 

echo "TRUNCATE ${raster_index};" | psql -w -h ${postgresql_host} -U geoadmin -d "${database}" ;  

