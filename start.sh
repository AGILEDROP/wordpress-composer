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

if [[ "$(uname -s)" == "Linux" ]]; then
  ifconfig lo:0 10.254.254.254
elif [[ "$(uname -s)" == "Darwin" ]]; then
  ifconfig lo0 alias 10.254.254.254
fi

docker-compose up -d
