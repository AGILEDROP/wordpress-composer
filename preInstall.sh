#!/bin/bash

mkdir temp

cp -avr wp/wp-content/plugins temp/

contentPlugins=()

for d in $(ls -d content/plugins/*)
do
  contentPlugins+=("${d//content\/plugins\/}")
done

for plugin in "${contentPlugins[@]}"
do
  dir="temp/plugins/${plugin}"
  if [ ! -d "$dir" ]; then
    cp -avr content/plugins/${plugin} temp/plugins/
  fi
done

cp -avr wp/wp-content/themes temp/
contentThemes=()
for d in $(ls -d content/themes/*)
do
  contentThemes+=("${d//content\/themes\/}")
done

for theme in "${contentThemes[@]}"
do
  dir="temp/themes/${theme}"
  if [ ! -d "$dir" ]; then
    cp -avr content/themes/${theme} temp/themes/
  fi
done

