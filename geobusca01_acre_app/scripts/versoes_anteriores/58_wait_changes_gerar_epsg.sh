#!/bin/bash
#----------------------------------------------
# Watch for changes BaseGeo script.
#----------------------------------------------
# Search for files in a directory script.
#----------------------------------------------
# Author Claudia Enk de Aguiar
#----------------------------------------------

script_name=`basename "$0" .sh`; 
	log_name="${script_name}.log"; 
		log_path="${log_dir}${log_name}";

file=${1};

source /BaseGeo/aplicativos/django_projects/geobusca01_acre_site/geobusca01_acre_app/scripts/00_wait_changes_variables_source.sh


awk -v nom=${file} -F "\"*,\"*" '$2 == nom {print $1}' ${epsg_exig_file} 
