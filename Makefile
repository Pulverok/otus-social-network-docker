init: docker-clear docker-down docker-up setup-composer mysql-init

docker-clear:
	sudo rm -rf config/nginx/logs/*.log
	sudo rm -rf db/schema/create_schema.sql

docker-down:
	docker-compose down --remove-orphans
	sudo rm -rf db/schema/create_schema.sql

docker-up:
	docker-compose up --build -d

docker-restart:
	docker-compose down
	docker-compose docker-up

pause:
	sleep 5

setup-composer:
	docker exec -w /var/www/tools/recreate-tool otus-social-network-docker_php_1 composer install
	docker exec -w /var/www/otus-social-network-api otus-social-network-docker_php_1 composer install

mysql-init:
	sh shell/recreate_mysql.sh

api-permissions:
	sudo chmod -R 777 ../backend.api/storage
