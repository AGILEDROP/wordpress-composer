#!/bin/bash

#Get all contrib plugins
contribPlugins=()
for plugin in $(ls -d contrib/plugins/*)
do
  contribPlugins+=("${plugin//contrib\/plugins\/}")
done

#Get all core plugins
corePlugins=()
coreThemes=()
for plugin in $(ls -d wp/wp-content/plugins/*)
do
  corePlugins+=("${plugin//wp\/wp-content\/plugins\/}")
done

#Compare core vs contrib, to see which was deleted from contrib
#and then delete it from core
for plugin in "${corePlugins[@]}"
do
  if [[ ! "${contribPlugins[@]}" =~ "${plugin}" ]]; then
    rm -rf wp/wp-content/plugins/${plugin}
  fi
done