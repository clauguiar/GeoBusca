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
 
for e in ${extensions[@]}; do 
	echo -n "INICIANDO BUSCA DOS ARQUIVOS .${e} DE ${wait_dir} EM "; date; 
	script_name=`basename "$0" .sh`; 
	echo "Script ${script_name}"; 
	echo
	find "${find_dir}" -type f -iname "*.${e}" -exec bash -c 'substr1="${0#*/}"; lyr_name="${substr1%%/*}"; echo "O nome da camada é ${lyr_name}"; nome=`basename "$0"`; echo "O nome do arquivo é ${nome}"; if grep -q -e "$nome" '"${epsg_exig_file}"'; then epsg_orig="$(awk -v nom="$nome" -F "\"*,\"*" '"'"'$2 == nom {print $1}'"'"' '"${epsg_exig_file}"')"; else epsg_orig="nenhum"; fi; echo "O epsg a ser usado é ${epsg_orig}"; gdaltindex -t_srs EPSG:4674 -lyr_name "${lyr_name}" '${shp_dir}'${epsg_orig}_tmp.shp "$0"' "{}" \; ;
sudo -H -u geoadmin <<-EOF
	shp2pgsql -a -I -s 4674 ${shp_dir}nenhum_tmp.shp "${raster_index}" | psql -w -h "${postgresql_host}" -p 5432 -d "${database}" -U geoadmin;  
	shp2pgsql -a -I -s 32722:4674 ${shp_dir}32722_tmp.shp "${raster_index}" | psql -w -h "${postgresql_host}" -p 5432 -d "${database}" -U geoadmin; 
	shp2pgsql -a -I -s 32721:4674 ${shp_dir}32721_tmp.shp "${raster_index}"| psql -w -h "${postgresql_host}" -p 5432 -d "${database}" -U geoadmin;
EOF
	rm ${shp_dir}*_tmp.*; 
done; 

# imagens que apresentam problemas de transformação: 
# devem ser informadas no arquivo [site]/[app]/scripts/epsg_files_egigent.csv
# no formato EPSG,NOME DO ARQUIVO

