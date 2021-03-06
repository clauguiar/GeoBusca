#!/bin/bash
#----------------------------------------------
# Watch for changes BaseGeo application.
#----------------------------------------------
# Initial table load script.
#----------------------------------------------
# Author Claudia Enk de Aguiar
#----------------------------------------------

source /BaseGeo/aplicativos/django_projects/geobusca01_acre_site/geobusca01_acre_app/scripts/00_wait_changes_variables_source.sh
script_name=`basename "$0" .sh`; 

#---- initial table load ----------------------

${script_dir}20_wait_changes_expand_compressed.sh "${wait_dir}";

for e in ${extensions[@]}; do 
	echo -n "INICIANDO BUSCA DOS ARQUIVOS .${e} DE ${search_dir} EM "; date; 
	script_name=`basename "$0" .sh`; 
	echo "Script ${script_name}"; 
	echo
	cd "${find_dir}";
	find "${search_dir}" -type f -iname "*.${e}" -exec ${script_dir}35_wait_changes_gdal_to_index.sh "{}" \; ;
done; 

# imagens que apresentam problemas de transformação: 
# devem ser informadas no arquivo [site]/[app]/scripts/epsg_files_egigent.csv
# no formato EPSG,NOME DO ARQUIVO

