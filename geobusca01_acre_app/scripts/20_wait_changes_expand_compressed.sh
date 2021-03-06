#!/bin/bash
#----------------------------------------------
# Watch for changes BaseGeo application.
#----------------------------------------------
# Expand compressed files script.
#----------------------------------------------
# Author Claudia Enk de Aguiar
#----------------------------------------------

source /BaseGeo/aplicativos/django_projects/geobusca01_acre_site/geobusca01_acre_app/scripts/00_wait_changes_variables_source.sh
script_name=`basename "$0" .sh`; 

expand_dir="$1";

#---- expand compressed -----------------------
 
echo

for c in ${!compressed[@]}; do 
	echo -n "INICIANDO DESCOMPACTAÇÃO DOS ARQUIVOS .${compressed[c]} DE ${expand_dir} EM "; date; 
	script_name=`basename "$0" .sh`; 
	echo "Script ${script_name}"; 
	echo; 
	find "${expand_dir}" -type f -iname "*.${compressed[c]}" -execdir bash -c 'compressed_file=`basename "$0"`; echo "${compressed_file}"; if [ '"${compressed[c]}"' == "zip" ]; then yes N | unzip -o -u "${compressed_file}"; else tar xf "${compressed_file}"; fi;' "{}" \; ; 
done; 


# imagens que apresentam problemas de transformação: 
# devem ser informadas no arquivo [site]/[app]/scripts/epsg_files_egigent.csv
# no formato EPSG,NOME DO ARQUIVO

