#!/bin/bash
#----------------------------------------------
# Watch for changes BaseGeo application.
#----------------------------------------------
# Log configuration script.
#----------------------------------------------
# Author Claudia Enk de Aguiar
#----------------------------------------------

source /BaseGeo/aplicativos/django_projects/geobusca01_acre_site/geobusca01_acre_app/scripts/00_wait_changes_variables_source.sh
script_name=`basename "$0" .sh`; 
	log_name="${script_name}.log"; 
		log_path="${log_dir}${log_name}"; 

#---- initial table load ----------------------

{ 
echo -n "INICIANDO ANÁLISE DE ${wait_dir} EM "; date; 
echo "Script ${script_name}"; 
echo; 

echo "Esvaziamento e preenchimento inicial da tabela"; 
echo; 

psql -W -U geoadmin -d "${database}" ;  
SELECT COUNT(1) FROM ${raster_index};
\q 

# imagens que apresentam problemas de transformação: 
# devem ser informadas no arquivo [site]/[app]/scripts/epsg_files_egigent.csv
# no formato EPSG,NOME DO ARQUIVO
 } 2>&1 | tee -a "${log_path}"
