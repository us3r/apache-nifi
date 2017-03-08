#!/bin/bash
set -e 

function set_nifi_properties()  {
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    for property in $(env | grep -i NIFI_ | grep -v HOME); do 
        key=$(echo $property | cut -f1 -d= | sed -e 's/_/./g' | tr A-Z a-z)
        value=$(eval echo $property | cut -f2 -d=)
        sed -e "s~$key=.*~$key=$value~" -i $NIFI_HOME/conf/nifi.properties
    done
    IFS=$SAVEIFS
}

function set_java() {
   JAVA_MS=${JAVA_MS:=1024}
   JAVA_MX=${JAVA_MX:=1024}
   sed -e "s/Xms.*/Xms${JAVA_MS}m/" -e "s/Xms.*/Xms${JAVA_MX}m/" -i $NIFI_HOME/conf/bootstrap.conf
}

function set_hdfs() {
 if [ $HDFS ]; then
   HDFS_URI=${HDFS_URI:=http://hdfs.marathon.mesos:9000/v1/connection}
   mkdir $NIFI_HOME/hdfs
   curl $HDFS_URI/core-site.xml > $NIFI_HOME/hdfs/core-site.xml
   curl $HDFS_URI/hdfs-site.xml > $NIFI_HOME/hdfs/hdfs-site.xml
 fi
}

set_nifi_properties
set_java
set_hdfs

exec "$@"
