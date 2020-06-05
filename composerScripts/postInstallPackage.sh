#!/bin/bash

#When user adds plugin/theme via composer require, check which plugin/theme was added
#and copy it to core
if [ -d "contrib/plugins" ] && [ -d "wp/wp-content/plugins" ]; then
  cd contrib/plugins
  installedPlugin=$(ls -ltr | tail -1 | grep -o '[^ ]*$')
  cd ..
  cd ..
  echo "Copy added plugin to core."
  if [ -d "contrib/plugins/$installedPlugin/.git" ]; then
    rsync contrib/plugins/$installedPlugin wp/wp-content/plugins/ --exclude contrib/plugins/$installedPlugin/.git
  else
    cp -R contrib/plugins/$installedPlugin wp/wp-content/plugins/
  fi
fi

if [ -d "contrib/themes" ] && [ -d "wp/wp-content/themes" ]; then
  cd contrib/themes
  installedTheme=$(ls -ltr | tail -1 | grep -o '[^ ]*$')
  cd ..
  cd ..
  echo "Copy added theme to core."
  if [ -d "contrib/themes/$installedTheme/.git" ]; then
    rsync contrib/themes/$installedTheme wp/wp-content/themes/ --exclude contrib/themes/$installedTheme/.git
  else
    cp -R contrib/themes/$installedTheme wp/wp-content/themes/
  fi
fi