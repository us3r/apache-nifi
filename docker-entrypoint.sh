#!/bin/bash
set -e 

function set_nifi_properties()  {
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    for property in $(env | grep -i NIFI_ | grep -v HOME); do 
        key=$(echo $property | cut -f1 -d= | sed -e 's/_/./g' | tr A-Z a-z)
        value=$(echo $property | cut -f2 -d=)
        sed -e "s/$key=.*/$key=$value/" -i $NIFI_HOME/conf/nifi.properties
    done
    IFS=$SAVEIFS
}

set_nifi_properties

exec "$@"
