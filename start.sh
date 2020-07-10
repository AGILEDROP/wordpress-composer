#!/usr/bin/env bash

script_path=$(dirname $0)
cd ${script_path}

composer install

if [[ ! -e ./.certs ]]; then
  mkdir ./.certs
fi

${script_path}/vendor/teamdeeson/docker-proxy/genlocalcrt.sh ./.certs

if [[ -z "$(docker network ls | fgrep -i agiledrop)" ]]; then
  docker network create agiledrop
fi

osType="$(uname -s)"

if [[ "$osType" == "Linux" ]]; then
  sudo ifconfig lo:0 10.254.254.254
fi
if [[ "$osType" == "Darwin" ]]; then
  sudo ifconfig lo0 alias 10.254.254.254
fi

docker-compose up -d

set -a
[[ -f .env ]] && . .env
set +a

echo  "Access site http://$PROJECT_HOSTNAME"
echo  "Access phpMyAdmin http://pma.$PROJECT_HOSTNAME"
