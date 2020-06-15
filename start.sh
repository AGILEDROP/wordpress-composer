#!/usr/bin/env bash

script_path=$(dirname $0)
cd ${script_path}

composer install

if [[ -z "$(docker network ls | fgrep -i agiledrop)" ]]; then
  docker network create agiledrop
fi

osType="$(uname -s)"

if [[ "$osType" == "Linux" ]]; then
  ifconfig lo:0 10.254.254.254
fi
if [[ "$osType" == "Darwin" ]]; then
  ifconfig lo0 alias 10.254.254.254
fi

cp composerScripts/traefik.toml ${script_path}/vendor/teamdeeson/docker-proxy/traefik.toml

docker-compose up -d

echo  "Access site http://adwp.localhost"
echo  "Access phpMyAdmin http://pma.adwp.localhost"
