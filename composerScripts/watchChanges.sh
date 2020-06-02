#!/bin/bash

daemon() {
    chsum1=""

    while [[ true ]]
    do
        chsum2=`tar -cf - custom/plugins | md5sum`
        if [[ $chsum1 != $chsum2 ]]; then
            chsum1=$chsum2
            cp -ru custom/plugins/* wp/wp-content/plugins
        fi
        sleep 1
    done
}

daemon $*