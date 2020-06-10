#!/bin/bash

#Copy last modified custom plugin to core
if [ -d "/dir1" ] && [ -d "/var/plugins" ]; then
  cd /dir1
  customPlugin=$(ls -ltr | tail -1 | grep -o '[^ ]*$')
  cd ..
  echo "Copy custom plugin to core."
  cp -R dir1/$customPlugin /var/plugins
fi

