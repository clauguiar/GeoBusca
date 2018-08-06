#!/bin/bash
#----------------------------------------------
# Watch for changes BaseGeo script.
#----------------------------------------------
# Monitor file system script.
#----------------------------------------------
# Author Claudia Enk de Aguiar
#----------------------------------------------

source /BaseGeo/aplicativos/django_projects/geobusca01_acre_site/geobusca01_acre_app/scripts/00_wait_changes_variables_source.sh

echo -n "INICIANDO ESPERA POR ALTERAÇÕES de ${wait_dir} em "; date;
script_name=`basename "$0" .sh`; 
echo "Script ${script_name}"; 
echo;

echo "Encerrar observação de diretório com Ctrl+C";
echo;
inotifywait -m -r "${wait_dir}" -e delete -e create -e move | while read path action file; do 
	echo "${path} ${action} ${file}";
	if [[ $action = *"MOVED_FROM"* || $action = *"DELETE"* ]]; then 
		sudo -H -u geoadmin "${script_dir}"55_wait_changes_delete_files.sh "${path}" "${file}";
		# echo "DELETE FROM ${raster_index} WHERE location like '"'"${path}${file}"'"' || '%';" | sudo -H -u geoadmin psql -w -h "${postgresql_host}" -p 5432 -d "${database}" -U geoadmin; 
	else 
		if [[ $action = *"ISDIR"* ]]; then 
				echo "$file é um diretório";
				"${script_dir}"32_wait_changes_find_rasters.sh;
			else
				file_extension="${file##*.}";
				low_file_ext="${file_extension,,}"; 
				echo "$file é um arquivo e sua extensão é ${low_file_ext}";
				for e in ${extensions}; do
					if [ ${e} = ${low_file_ext} ]; then 
						echo "${low_file_ext} is equal to ${e}"; 
						pathfile="${path}${file}"; 
						${script_dir}35_wait_changes_gdal_to_index.sh "${pathfile}";
						if grep -q -e "$nome" "${epsg_exig_file}"; then 
							epsg_orig=$(grep -e "$nome" "${epsg_exig_file}" | cut -d "," -f 1); 
						else 
							epsg_orig="nenhum"; 
						fi; 
						echo "O epsg a ser usado é ${epsg_orig}"; 
						sudo -H -u geoadmin "${script_dir}"30_wait_changes_shape_to_pgsql.sh "${epsg_orig}";
						rm ${shp_dir}*_tmp.*
					else 
						echo "${low_file_ext} é diferente de ${e}"; 
					fi; 
				done;
			fi;
		sudo -H -u geoadmin ${script_dir}40_wait_changes_insert_date.sh &
	fi; 
done;


