#!/bin/bash
#----------------------------------------------
# Watch for changes BaseGeo script.
#----------------------------------------------
# Insert dates script.
#----------------------------------------------
# Author Claudia Enk de Aguiar
#----------------------------------------------

source /BaseGeo/aplicativos/django_projects/geobusca01_acre_site/geobusca01_acre_app/scripts/00_wait_changes_variables_source.sh

echo -n "Inserindo as datas na tabela ${raster_index} do banco de dados ${database} no servidor ${postgresql_host} em "; date;
script_name=`basename "$0" .sh`; 
echo "Script ${script_name}"; 
echo
psql -w -h "${postgresql_host}" -p 5432 -d "${database}" -U geoadmin <<EOF
update ${raster_index} set acq_date=to_date(substring(location from position('201' in location) for 8), 'YYYYMMDD') where acq_date IS NULL AND substring(location from position('201' in location) for 8) ~ '^[0-9\.]+$' AND to_date(substring(location from position('201' in location) for 8), 'YYYYMMDD') > '19700101' AND to_date(substring(location from position('201' in location) for 8), 'YYYYMMDD') < current_date; 
update ${raster_index} set acq_date=to_date(substring(location from position('_20' in location)+1 for 8), 'YYYYDDMM') where acq_date IS NULL AND substring(location from position('_20' in location)+1 for 8) ~ '^[0-9\.]+$' AND to_date(substring(location from position('_20' in location)+1 for 8), 'YYYYMMDD') > '19700101' AND to_date(substring(location from position('_20' in location)+1 for 8), 'YYYYMMDD') < current_date;
update ${raster_index} set acq_date=to_date(substring(location from position('201' in location) for 10), 'YYYY-MM-DD') where acq_date IS NULL AND lower(substring(location from position('201' in location) for 10)) !~ '[a-z]' AND to_date(substring(location from position('201' in location) for 10), 'YYYY-MM-DD') > '19700101' AND to_date(substring(location from position('201' in location) for 10), 'YYYY-MM-DD') < current_date; 
update ${raster_index} set acq_date=to_date(substring(location from position('200' in location)-5 for 9), 'DD.M.YYYY') where acq_date IS NULL AND lower(substring(location from position('200' in location)-5 for 9)) !~ '[a-z]' AND to_date(substring(location from position('200' in location)-5 for 9), 'DD.M.YYYY') > '19700101' AND to_date(substring(location from position('200' in location)-5 for 9), 'DD.M.YYYY') < current_date;
update ${raster_index} set acq_date=to_date(substring(location from '[0-9]{2}[0-9]{2}[0-9]{4}'), 'DDMMYYY') where acq_date IS NULL AND to_date(substring(location from '[0-9]{2}[0-9]{2}[0-9]{4}'), 'DDMMYYY') > to_date('01011970', 'DDMMYYY') AND to_date(substring(location from '[0-9]{2}[0-9]{2}[0-9]{4}'), 'DDMMYYY') < current_date;
update ${raster_index} set acq_date=to_date('20041113', 'YYYYMMDD') where acq_date IS NULL and location like 'IMAGENS_SATELITE/SPOT_5/IMAGENS SPOT - NÃO ORTORRETIFICADAS/%';
update ${raster_index} set acq_date=to_date(substring(location from position('_19' in location)+1 for 8), 'YYYYDDMM') where acq_date IS NULL AND substring(location from position('_19' in location)+1 for 8) ~ '^[0-9\.]+$' AND to_date(substring(location from position('_19' in location)+1 for 8), 'YYYYMMDD') > '19700101' AND to_date(substring(location from position('_19' in location)+1 for 8), 'YYYYMMDD') < '20000101'; 
update ${raster_index} set acq_year=extract(year from acq_date) where acq_year is null and acq_date is not null; 
update ${raster_index} set acq_year=cast(substring(location from position('_19' in location)+1 for 4) as int) where acq_year is null and acq_date IS NULL AND substring(location from position('_19' in location)+1 for 4) ~ '^[0-9\.]+$' AND cast(substring(location from position('_19' in location)+1 for 4) as int) > '1970' AND cast(substring(location from position('_19' in location)+1 for 4) as int) < '2000'; 
update ${raster_index} set acq_year=cast(substring(location from position('_20' in location)+1 for 4) as int) where acq_year is null and acq_date IS NULL AND substring(location from position('_20' in location)+1 for 4) ~ '^[0-9\.]+$' AND cast(substring(location from position('_20' in location)+1 for 4) as int) > '1970' AND cast(substring(location from position('_20' in location)+1 for 4) as int) < date_part('year', current_date); 
update ${raster_index} set acq_year=cast(substring(location from position('19' in location) for 4) as int) where acq_year is null and acq_date IS NULL AND substring(location from position('19' in location) for 4) ~ '^[0-9\.]+$' AND cast(substring(location from position('19' in location) for 4) as int) > '1970' AND cast(substring(location from position('19' in location) for 4) as int) < '2000'; 
update ${raster_index} set acq_year=cast(substring(location from position('200' in location) for 4) as int) where acq_year is null and acq_date IS NULL AND substring(location from position('200' in location) for 4) ~ '^[0-9\.]+$' AND cast(substring(location from position('200' in location) for 4) as int) > '1999' AND cast(substring(location from position('200' in location) for 4) as int) < '2010'; 
update ${raster_index} set acq_year=cast(substring(location from position('201' in location) for 4) as int) where acq_year is null and acq_date IS NULL AND substring(location from position('201' in location) for 4) ~ '^[0-9\.]+$' AND cast(substring(location from position('201' in location) for 4) as int) > '2009' AND cast(substring(location from position('201' in location) for 4) as int) < '2020'; 
EOF
