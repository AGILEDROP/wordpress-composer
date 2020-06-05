#!/bin/bash

if [ -d "contrib/plugins" ] && [ -d "wp/wp-content/plugins" ]; then
  cd contrib/plugins
  installedPlugin=$(ls -ltr | tail -1 | grep -o '[^ ]*$')
  cd ..
  cd ..
  cp -ru contrib/plugins/$installedPlugin wp/wp-content/plugins/
fi