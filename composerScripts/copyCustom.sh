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

#Get all core plugins
corePlugins=()
if [ -d "/var/plugins" ]; then
  for plugin in $(ls -d /var/plugins/*)
  do
    corePlugins+=("${plugin//\/var\/plugins\/}")
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

#Get all custom plugins
customPlugins=()
if [ -d "/dir1" ]; then
  for plugin in $(ls -d /dir1/*)
  do
    customPlugins+=("${plugin//\/dir1\/}")
  done
fi

#Check if user deleted custom plugin
deletedPlugins=${corePlugins[@]}

echo "Before loop"
for a in "${deletedPlugins[@]}"
do
  echo "$a"
done

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

echo "After loop"
for a in "${deletedPlugins[@]}"
do
  echo "$a"
done

#Delete custom plugins from core
