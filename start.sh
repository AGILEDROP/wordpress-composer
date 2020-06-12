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
  ifconfig lo:0 10.254.254.254
elif [[ "$osType" == "Darwin" ]]; then
  ifconfig lo0 alias 10.254.254.254
fi

if [[ "$osType" == "Linux" ]]; then
  sudo cp .certs/* /usr/local/share/ca-certificates/
  sudo update-ca-certificates
fi

if [[ "$osType" == "Darwin" ]]; then
  sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" ".certs/local.crt"
fi

docker-compose up -d
