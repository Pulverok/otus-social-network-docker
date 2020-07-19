#!/bin/sh

# mysql recreating
GENERATOR_SCHEMA_PATH=/var/www/tools/recreate-tool
MAIN_DB_SCHEMA_PATH=../otus-social-network-db
SCRIPTS_PATH=db/schema
MYSQL_PWD=root
set -e

echo 'GENERATE RECREATE SCRIPT FOR mainDb'
docker exec -w ${GENERATOR_SCHEMA_PATH} otus-social-network-docker_php_1 php generate_schema_script.php

echo 'ЗАДЕРЖКА ПОДНЯТИЯ MYSQL'
while ! echo "mysqladmin ping -h"192.168.30.10" --silent" | docker exec -i otus-social-network-docker_php_1 bash; do
    sleep 1
done

echo 'DROP OLD DATABASE'
cat ${SCRIPTS_PATH}/drop_old_database.sql | docker exec -i otus-social-network-docker_mysql_1 bash -c "exec mysql -uroot -p${MYSQL_PWD}"

sleep 1

echo 'CREATE DATABASE'
cat ${MAIN_DB_SCHEMA_PATH}/initialize_database.sql | docker exec -i otus-social-network-docker_mysql_1 bash -c "exec mysql -uroot -p${MYSQL_PWD}"

sleep 1

echo 'CREATE USERS'
cat ${MAIN_DB_SCHEMA_PATH}/initialize_users.sql | docker exec -i otus-social-network-docker_mysql_1 bash -c "exec mysql -uroot -p${MYSQL_PWD} otus_social_network"

sleep 1

echo 'CREATE PERMISSIONS'
cat ${MAIN_DB_SCHEMA_PATH}/initialize_permissions.sql | docker exec -i otus-social-network-docker_mysql_1 bash -c "exec mysql -uroot -p${MYSQL_PWD} otus_social_network"

sleep 1

echo 'CREATE SCHEMA'
cat ${SCRIPTS_PATH}/create_schema.sql | docker exec -i otus-social-network-docker_mysql_1 bash -c "exec mysql -uroot -p${MYSQL_PWD} otus_social_network"


if [ $? -eq 0 ]; then
    echo
    echo 'MySQL success!'
else
    echo
    echo 'MySQL failed!'
fi
