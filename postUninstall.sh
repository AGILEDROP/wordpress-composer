#!/bin/bash

tempPlugins=()
for d in $(ls -d temp/plugins/*)
do
  tempPlugins+=("${d//temp\/plugins\/}")
done

contentPlugins=()
for d in $(ls -d content/plugins/*)
do
  contentPlugins+=("${d//content\/plugins\/}")
done


for deletePlugin in "${tempPlugins[@]}"
do
  if [[ ! "${contentPlugins[@]}" =~ "${deletePlugin}" ]]; then
    dir="wp/wp-content/plugins/${deletePlugin}"
    rm -rf ${dir}
  fi
done

tempThemes=()
for d in $(ls -d temp/themes/*)
do
  tempThemes+=("${d//temp\/themes\/}")
done

contentThemes=()
for d in $(ls -d content/themes/*)
do
  contentThemes+=("${d//content\/themes\/}")
done

for deleteTheme in "${tempThemes[@]}"
do
  if [[ ! "${contentThemes[@]}" =~ "${deleteTheme}" ]]; then
    dir="wp/wp-content/themes/${deleteTheme}"
    rm -rf ${dir}
  fi
done

rm -rf temp
