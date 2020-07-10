#!/usr/bin/env bash
script_path=$(dirname $0)
cd ${script_path}

set -o allexport
[[ -f .env ]] && source .env
set +o allexport

if [[ ${WP_USE_SSL} == 1 ]]
then
  PROTOCOL=https
else
  PROTOCOL=http
fi

vendor/bin/wp config create --dbname=${WP_DB_NAME} --dbuser=${WP_DB_USER} --dbpass=${WP_DB_PASS} --dbhost=${WP_DB_HOST} --dbprefix=${WP_DB_PREFIX} --dbcharset=${WP_DB_CHARSET} --dbcollate=${WP_DB_COLLATE} --force --allow-root
vendor/bin/wp core install --url=${PROTOCOL}://${PROJECT_HOSTNAME} --title=${PROJECT_NAME} --allow-root
vendor/bin/wp theme activate wordpress-ad-theme --allow-root
vendor/bin/wp rewrite flush --allow-root