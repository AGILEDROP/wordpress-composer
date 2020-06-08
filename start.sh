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

echo "Pulling image, to watch custom directory changes."
docker pull coppit/inotify-command


if docker ps -a | grep -q 'coppit/inotify-command'; then
  containerId=$(docker ps -a | grep "coppit/inotify-command" | cut -d ' ' -f1)
  docker stop $containerId
  docker rm $containerId
fi

dirToWatch="/dir/path:"
dirToWatch+=$(pwd)
dirToWatch+="/custom/plugins"

sudo docker run --name=inotify-command -d -v /etc/localtime:/etc/localtime -v /config/dir/path:/config:rw -v $dirToWatch coppit/inotify-command
if [ ! -f "/config/dir/path/custom.conf" ]; then
  sudo touch /config/dir/path/custom.conf
fi

watchDir="WATCH_DIR="
watchDir+=$(pwd)
watchDir+="/custom/plugins"

echo "Setting watcher for custom directory"

echo "$watchDir" | sudo tee /config/dir/path/custom.conf
echo -e 'SETTLE_DURATION=5
        MAX_WAIT_TIME=05:00
        MIN_PERIOD=10:00
        COMMAND="touch novaDatoteka.php"
        USER_ID=0
        GROUP_ID=0
        UMASK=0000
        IGNORE_EVENTS_WHILE_COMMAND_IS_RUNNING=1
        USE_POLLING=NO
        DEBUG=0' | sudo tee -a /config/dir/path/custom.conf

if [ -f '/config/dir/path/sample.conf' ]; then
  sudo rm /config/dir/path/sample.conf
fi

docker logs inotify-command
