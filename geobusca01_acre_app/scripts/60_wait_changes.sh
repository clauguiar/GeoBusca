#!/bin/bash
#----------------------------------------------
# Watch for changes BaseGeo script.
#----------------------------------------------
# Author Claudia Enk de Aguiar
#----------------------------------------------

source /BaseGeo/aplicativos/django_projects/geobusca01_acre_site/geobusca01_acre_app/scripts/00_wait_changes_variables_source.sh;

script_name=`basename "$0" .sh`; 
	log_name="${script_name}.log"; 
		log_path="${log_dir}${log_name}";

touch "${log_path}";
echo "Iniciando log em ${log_path}."

#---- execution -------------------------------

{

"${script_dir}"10_wait_changes_log_organization.sh;
sudo -H -u geoadmin "${script_dir}"22_wait_changes_table_truncate.sh;
"${script_dir}"32_wait_changes_find_rasters.sh;
sudo -H -u geoadmin "${script_dir}"30_wait_changes_shape_to_pgsql.sh "nenhum";
for p in $(cut -d "," -f 1 epsg_files_exigent.csv | sort | uniq); do  
sudo -H -u geoadmin "${script_dir}"30_wait_changes_shape_to_pgsql.sh "${p}";
done;
rm ${shp_dir}*_tmp.*
sudo -H -u geoadmin ${script_dir}40_wait_changes_insert_date.sh &
${script_dir}50_wait_changes_monitor_fs.sh;

} 2>&1 | tee -a "${log_path}"
exit 0;
