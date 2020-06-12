#!/bin/bash

#Check if wp exists
wpPluginDir=true
wpThemeDir=true
if [ ! -d "wp/wp-content/plugins" ]; then
  wpPluginDir=false
fi
if [ ! -d "wp/wp-content/themes" ]; then
  wpThemeDir=false
fi

#Check if contrib exists
conPluginDir=true
conThemeDir=true
if [ ! -d "contrib/plugins" ]; then
  conPluginDir=false
fi
if [ ! -d "contrib/themes" ]; then
  conThemeDir=false
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

#Remove default themes
if $wpThemeDir ; then
  rm -rf wp/wp-content/themes/*
  touch wp/wp-content/themes/index.php
  echo "<?php //Silence is golden" > wp/wp-content/plugins/index.php
fi

#Copy contrib to core
if $conPluginDir ; then
  cp -R contrib/plugins/* wp/wp-content/plugins
fi
if $conThemeDir ; then
  cp -R contrib/themes/* wp/wp-content/themes
fi

#Copy custom plugins to core
if $cusPluginDir ; then
  subDirCount=`find custom/plugins/ -maxdepth 1 -type d | wc -l`
  if [ $subDirCount -eq 2 ]; then
    cp -R custom/plugins/* wp/wp-content/plugins
  fi
fi

