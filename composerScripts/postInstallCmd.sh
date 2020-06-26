#!/bin/bash

#Check if wp exists
wpPluginDir=true
if [ ! -d "wp/wp-content/plugins" ]; then
  wpPluginDir=false
fi

#Check if contrib exists
conPluginDir=true
if [ ! -d "contrib/plugins" ]; then
  conPluginDir=false
fi

#Check if custom exists
cusPluginDir=true
if [ ! -d "custom/plugins" ]; then
  cusPluginDir=false
fi

#Remove default plugins
if $wpPluginDir ; then
  rm -rf wp/wp-content/plugins/*
  touch wp/wp-content/plugins/index.php
  echo "<?php //Silence is golden" > wp/wp-content/plugins/index.php
fi


#Copy contrib to core
if $conPluginDir ; then
  subDirCount=`find contrib/plugins -maxdepth 1 -type d | wc -l`
  if [ $subDirCount -gt 1 ]; then
    cp -R contrib/plugins/* wp/wp-content/plugins
  fi
fi

#Copy custom plugins to core
if $cusPluginDir ; then
  subDirCount=`find custom/plugins/ -maxdepth 1 -type d | wc -l`
  if [ $subDirCount -gt 1 ]; then
    cp -R custom/plugins/* wp/wp-content/plugins
  fi
fi

