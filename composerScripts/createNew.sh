#!/bin/bash

echo "Insert name of your plugin, no spaces allowed use camelCase"
read plugin
plugin="$(echo -e "${plugin}" | tr -d '[:space:]')"

dir="custom/plugins/"
if [ ! -d "$dir" ];then
  mkdir custom
  mkdir custom/plugins/
fi
dirPlugin="custom/plugins/${plugin}"
if [ ! -d "$dirPlugin" ];then
  mkdir custom/plugins/${plugin}
else
  echo "Custom plugin with this name already exists"
fi