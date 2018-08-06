#!/bin/bash
#----------------------------------------------
# Watch for changes BaseGeo application.
#----------------------------------------------
# Log configuration script.
#----------------------------------------------
# Author Claudia Enk de Aguiar
#----------------------------------------------

source /BaseGeo/aplicativos/django_projects/geobusca01_acre_site/geobusca01_acre_app/scripts/00_wait_changes_variables_source.sh

#---- initial log configuration ---------------


echo;
echo "INICIANDO A CONFIGURAÇAO DE LOG "
echo;
if [ ! -d "${log_dir}" ]; then
	echo "Criando o diretório de log";
	mkdir -p "${log_dir}"; 
	echo;
fi;

echo -n "INICIANDO A CONFIGURAÇAO DE ROTAÇÃO DE LOG em "; date;
script_name=`basename "$0" .sh`; 
echo "Script ${script_name}"; 
echo;

if [ -f "${logrotate_file}" ]; then
	echo "Removendo o antigo arquivo de configuração de rotação de log";
	echo; 
	rm "${logrotate_file}"
fi;

# ao criar mais de um monitoramento de diretório, alterar este grupo
echo "Criando o arquivo de configuração de rotação de log"; 
echo; 
cat >"${logrotate_file}" <<EOL
	${log_dir} {
        weekly
        missingok
        notifempty
        rotate 7
        mail claudia.aguiar@gmail.com
        compress
        create 644 root root
}
EOL

cat "${logrotate_file}"

echo "Configuração do log finalizada."; 
echo;  

echo -n "INICIANDO A CONFIGURAÇAO DE ACESSO AO BANCO EM "; date;
echo;

if [ ! -f "${geoadmin_pass}" ]; then 
	echo "Criando arquivo de configuração da senha para o psql para o usuário geoadmin"; 
	echo; 
	touch "${geoadmin_pass}"; 
	chmod 600 "${geoadmin_pass}"; 
fi; 

if grep -Fxq "${postgresql_host}:5432:${database}:geoadmin:142536" "${geoadmin_pass}"; then 
	echo "Permissão ao usuário geoadmin para acessar o ${database} previamente concedida, nada a fazer."; 
else 
	echo "Concedendo permissão ao geoadmin para acessar o ${database}"; 
	echo; 
	echo "${postgresql_host}:5432:${database}:geoadmin:142536" | tee -a "${geoadmin_pass}"; 
fi; 

# O usuário proprietário do arquivo de senha do pgsql deve ser o que conecta no banco
echo "Definindo o proprietário e grupo de ${geoadmin_pass}.";
chown geoadmin:geoadmin "${geoadmin_pass}";
ls -l "${geoadmin_pass}";
