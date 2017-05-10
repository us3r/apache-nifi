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
   sed -e "s/Xms.*/Xms${JAVA_MS}m/" -e "s/Xmx.*/Xmx${JAVA_MX}m/" -i $NIFI_HOME/conf/bootstrap.conf
}

function set_hdfs() {
 if [ ${HDFS_SERVICE_NAME} ]; then
  mkdir -p $NIFI_HOME/hdfs
  API_PORT=$(dig _${HDFS_SERVICE_NAME}._tcp.marathon.mesos SRV +short | cut -d " " -f 3)
  wget -O $NIFI_HOME/hdfs/core-site.xml "${HDFS_SERVICE_NAME}.marathon.mesos:${API_PORT}/v1/endpoints/core-site.xml"
  wget -O $NIFI_HOME/hdfs/hdfs-site.xml "${HDFS_SERVICE_NAME}.marathon.mesos:${API_PORT}/v1/endpoints/hdfs-site.xml"
 fi
}



set_nifi_properties
set_java
set_hdfs

exec "$@"
