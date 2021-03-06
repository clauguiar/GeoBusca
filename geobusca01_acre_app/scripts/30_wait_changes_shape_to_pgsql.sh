#!/bin/bash
#----------------------------------------------
# Watch for changes BaseGeo application.
#----------------------------------------------
# Initial table load script.
#----------------------------------------------
# Author Claudia Enk de Aguiar
#----------------------------------------------

source /BaseGeo/aplicativos/django_projects/geobusca01_acre_site/geobusca01_acre_app/scripts/00_wait_changes_variables_source.sh

echo -n "LANÇANDO ARQUIVOS SHAPE COM EPSG ${epsg} PARA O BANCO EM "; date;
script_name=`basename "$0" .sh`; 
echo "Script ${script_name}";

epsg_orig="$1";
nenhum_src="nenhum";
if [ ${epsg_orig} = ${nenhum_src} ]; then
	epsg="4674";
else
	epsg="${epsg_orig}:4674";
fi;
#---- initial table load ----------------------
 
shp2pgsql -a -I -s ${epsg} ${shp_dir}${epsg_orig}_tmp.shp "${raster_index}" | psql -w -h "${postgresql_host}" -p 5432 -d "${database}" -U geoadmin 

# imagens que apresentam problemas de transformação: 
# devem ser informadas no arquivo [site]/[app]/scripts/epsg_files_egigent.csv
# no formato EPSG,NOME DO ARQUIVO

