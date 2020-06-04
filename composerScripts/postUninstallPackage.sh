#!/bin/bash

#Get all contrib plugins&themes
contribPlugins=()
contribThemes=()
for plugin in $(ls -d contrib/plugins/*)
do
  contribPlugins+=("${plugin//contrib\/plugins\/}")
done
for theme in $(ls -d contrib/themes/*)
do
  contribThemes+=("${theme//contrib\/themes\/}")
done

#Get all core plugins&themes
corePlugins=()
coreThemes=()
for plugin in $(ls -d wp/wp-content/plugins/*)
do
  corePlugins+=("${plugin//wp\/wp-content\/plugins\/}")
done
for theme in $(ls -d wp/wp-content/themes/*)
do
  coreThemes+=("${d//wp\/wp-content\/themes\/}")
done

#Compare core vs contrib, to see which was deleted from contrib
#and then delete it from core
for plugin in "${corePlugins[@]}"
do
  if [[ ! "${contribPlugins[@]}" =~ "${plugin}" ]]; then
    rm -rf wp/wp-content/plugins/${plugin}
  fi
done

for theme in "${coreThemes[@]}"
do
  if [[ ! "${contribThemes[@]}" =~ "${theme}" ]]; then
    rm -rf wp/wp-content/themes/${theme}
  fi
done