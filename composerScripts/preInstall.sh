#!/bin/bash

mkdir temp

cp -avr wp/wp-content/plugins temp/

contribPlugins=()

for d in $(ls -d contrib/plugins/*)
do
  contribPlugins+=("${d//contrib\/plugins\/}")
done

for plugin in "${contribPlugins[@]}"
do
  dir="temp/plugins/${plugin}"
  if [ ! -d "$dir" ]; then
    cp -avr contrib/plugins/${plugin} temp/plugins/
  fi
done

cp -avr wp/wp-content/themes temp/
contribThemes=()
for d in $(ls -d contrib/themes/*)
do
  contribThemes+=("${d//contrib\/themes\/}")
done

for theme in "${contribThemes[@]}"
do
  dir="temp/themes/${theme}"
  if [ ! -d "$dir" ]; then
    cp -avr contrib/themes/${theme} temp/themes/
  fi
done

