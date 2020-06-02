#!/bin/bash

contribPlugins=()
for d in $(ls -d contrib/plugins/*)
do
  contribPlugins+=("${d//contrib\/plugins\/}")
done

corePlugins=()
for d in $(ls -d wp/wp-content/plugins/*)
do
  corePlugins+=("${d//wp\/wp-content\/plugins\/}")
done

for plugin in "${contribPlugins[@]}"
do
  dir="temp/plugins/${plugin}"
  if [ ! -d "$dir" ]; then
    cp -avr contrib/plugins/${plugin} temp/plugins/
  fi
done

for plugin in "${corePlugins[@]}"
do
  dir="temp/plugins/${plugin}"
  if [ ! -d "$dir" ]; then
    cp -avr wp/wp-content/plugins/${plugin} temp/plugins/
  fi
done

cp -avr temp/plugins/* wp/wp-content/plugins/

contribThemes=()
for d in $(ls -d contrib/themes/*)
do
  contribThemes+=("${d//contrib\/themes\/}")
done

coreThemes=()
for d in $(ls -d wp/wp-content/themes/*)
do
  coreThemes+=("${d//wp\/wp-content\/themes\/}")
done

for theme in "${contentThemes[@]}"
do
  dir="temp/themes/${theme}"
  if [ ! -d "$dir" ]; then
    cp -avr content/themes/${theme} temp/themes/
  fi
done

for theme in "${coreThemes[@]}"
do
  dir="temp/themes/${theme}"
  if [ ! -d "$dir" ]; then
    cp -avr wp/wp-content/themes/${theme} temp/themes/
  fi
done

cp -avr temp/themes/* wp/wp-content/themes/

rm -rf temp