#!/usr/bin/env bash
script_path=$(dirname $0)
cd ${script_path}

set -o allexport
[[ -f .env ]] && source .env
set +o allexport

docker-compose exec -u www-data web vendor/bin/wp config create --dbname=${WP_DB_NAME} --dbuser=${WP_DB_USER} --dbpass=${WP_DB_PASS} --dbhost=${WP_DB_HOST} --dbprefix=${WP_DB_PREFIX} --dbcharset=${WP_DB_CHARSET} --dbcollate=${WP_DB_COLLATE} --force
docker-compose exec -u www-data web vendor/bin/wp core install --url=https://${PROJECT_HOSTNAME} --title=${PROJECT_NAME}
docker-compose exec -u www-data web vendor/bin/wp theme activate wordpress-ad-theme
docker-compose exec -u www-data web vendor/bin/wp rewrite flush