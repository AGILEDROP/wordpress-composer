#!/bin/bash

tempPlugins=()
for d in $(ls -d temp/plugins/*)
do
  tempPlugins+=("${d//temp\/plugins\/}")
done

contribPlugins=()
for d in $(ls -d contrib/plugins/*)
do
  contribPlugins+=("${d//contrib\/plugins\/}")
done


for deletePlugin in "${tempPlugins[@]}"
do
  if [[ ! "${contribPlugins[@]}" =~ "${deletePlugin}" ]]; then
    dir="wp/wp-content/plugins/${deletePlugin}"
    rm -rf ${dir}
  fi
done

tempThemes=()
for d in $(ls -d temp/themes/*)
do
  tempThemes+=("${d//temp\/themes\/}")
done

contribThemes=()
for d in $(ls -d contrib/themes/*)
do
  contribThemes+=("${d//contrib\/themes\/}")
done

for deleteTheme in "${tempThemes[@]}"
do
  if [[ ! "${contribThemes[@]}" =~ "${deleteTheme}" ]]; then
    dir="wp/wp-content/themes/${deleteTheme}"
    rm -rf ${dir}
  fi
done

rm -rf temp
