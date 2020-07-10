#!/bin/bash

#Copy last modified custom plugin to core
if [ -d "/dir1" ] && [ -d "/var/plugins" ]; then
  cd /dir1
  customPlugin=$(ls -ltr | tail -1 | grep -o '[^ ]*$')
  if [ $customPlugin != 0 ]; then
    cd ..
    echo "Copy custom plugin to core."
    cp -R dir1/$customPlugin /var/plugins
  fi
fi

#Copy last modified custom theme to core
if [ -d "/dir2" ] && [ -d "/var/themes" ]; then
  cd /dir2
  customTheme=$(ls -ltr | tail -1 | grep -o '[^ ]*$')
  if [ $customTheme != 0 ]; then
    cd ..
    echo "Copy custom theme to core."
    cp -R dir2/$customTheme /var/themes
  fi
fi

#Get all core plugins
corePlugins=()
if [ -d "/var/plugins" ]; then
  for plugin in $(ls -d /var/plugins/*)
  do
    corePlugins+=("${plugin//\/var\/plugins\/}")
  done
fi

#Get all core themes
coreThemes=()
if [ -d "/var/themes" ]; then
  for theme in $(ls -d /var/themes/*)
  do
    coreThemes+=("${theme//\/var\/themes\/}")
  done
fi

#Get all contrib plugins
contribPlugins=()
if [ -d "/contrib/plugins" ]; then
  for plugin in $(ls -d /contrib/plugins/*)
  do
    contribPlugins+=("${plugin//\/contrib\/plugins\/}")
  done
fi

#Get all contrib themes
contribThemes=()
if [ -d "/contrib/themes" ]; then
  for theme in $(ls -d /contrib/themes/*)
  do
    contribThemes+=("${theme//\/contrib\/themes\/}")
  done
fi

#Get all custom plugins
customPlugins=()
if [ -d "/dir1" ]; then
  subDir=`find /dir1/ -maxdepth 1 -type d | wc -l`
  if [ $subDir -gt 1 ]; then
    for plugin in $(ls -d /dir1/*)
    do
      customPlugins+=("${plugin//\/dir1\/}")
    done
  fi
fi

#Get all custom themes
customThemes=()
if [ -d "/dir2" ]; then
  subDir=`find /dir2/ -maxdepth 1 -type d | wc -l`
  if [ $subDir -gt 1 ]; then
    for theme in $(ls -d /dir2/*)
    do
      customThemes+=("${theme//\/dir2\/}")
    done
  fi
fi

#Check if user deleted custom plugin
deletedPlugins=${corePlugins[@]}

for del in "${contribPlugins[@]}"
do
  if [[ "${deletedPlugins}" =~ "${del}" ]]; then
    deletedPlugins="${deletedPlugins[@]/$del}"
  fi
done

for del in "${customPlugins[@]}"
do
  if [[ "${deletedPlugins}" =~ "${del}" ]]; then
    deletedPlugins="${deletedPlugins[@]/$del}"
  fi
done

#Delete custom plugins from core
for del in "${deletedPlugins[@]}"
do
  cd /var/plugins
  rm -rf $del
done

#Check if user deleted custom theme
deletedThemes=${coreThemes[@]}

for del in "${contribThemes[@]}"
do
  if [[ "${deletedThemes}" =~ "${del}" ]]; then
    deletedThemes="${deletedThemes[@]/$del}"
  fi
done

for del in "${customThemes[@]}"
do
  if [[ "${deletedThemes}" =~ "${del}" ]]; then
    deletedThemes="${deletedThemes[@]/$del}"
  fi
done

#Delete custom theme from core
for del in "${deletedThemes[@]}"
do
  cd /var/themes
  rm -rf $del
done
