#!/bin/bash

cd contrib/plugins
installedPlugin=$(ls -ltr | tail -1 | grep -o '[^ ]*$')
cd ..
cd ..
cp -ru contrib/plugins/$installedPlugin wp/wp-content/plugins/
