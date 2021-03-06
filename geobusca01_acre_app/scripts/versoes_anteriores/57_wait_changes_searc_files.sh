#!/bin/bash
#----------------------------------------------
# Watch for changes BaseGeo script.
#----------------------------------------------
# Search for files in a directory script.
#----------------------------------------------
# Author Claudia Enk de Aguiar
#----------------------------------------------

source /BaseGeo/aplicativos/django_projects/geobusca01_acre_site/geobusca01_acre_app/scripts/00_wait_changes_variables_source.sh

e=${1};
path="${2}";
file="${3}";

echo -n "INICIANDO BUSCA DOS ARQUIVOS .${e} DE ${path}${file} EM "; date; 
	script_name=`basename "$0" .sh`; 
	echo "Script ${script_name}"; 
	echo; 
	
echo "Os arquivos com a extensão ${e} na localização ${path}${file} precisam ser encontrados."
find "${wait_dir}${path}${file}/" -type f -iname "*.${e}" -exec bash -c 'nome=`basename "$0"`; echo "O nome do arquivo é ${nome}"; if grep -q -e "${nome}" '"${epsg_exig_file}"'; then epsg="$(awk -v nom="$nome" -F "\"*,\"*" '"'"'$2 == nom {print $1}'"'"' '"${epsg_exig_file}"'):4674"; else epsg="4674"; fi; echo "O epsg a ser usado é ${epsg}"; gdaltindex -t_srs EPSG:4674 -lyr_name '"${lyr_name}"' tmp.shp "$0"; shp2pgsql -a -I -s ${epsg} tmp.shp '"${raster_index}"' | psql -w -d '"${database}"' -U geoadmin; rm tmp.*' "{}" \; ; 
