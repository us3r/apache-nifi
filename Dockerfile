FROM openjdk:8-alpine

MAINTAINER Mariusz Derela <mariusz.derela@gmail.com>

# Environment variables
ENV     NIFI_HOME   /opt/nifi

# ARGS
ARG     DIST_MIRROR=https://dlcdn.apache.org/nifi
ARG     VERSION=1.19.1

# Create Environment, install depedencies

RUN     apk update && apk add --upgrade bash curl bind-tools && \
        bash -c "mkdir -p $NIFI_HOME/{flowfile_repository,database_repository,content_repository,provenance_repository}" && \
        curl -O ${DIST_MIRROR}/${VERSION}/nifi-${VERSION}-bin.zip && \
        unzip nifi-${VERSION}-bin.zip -d ${NIFI_HOME} && \
        mv ${NIFI_HOME}/nifi-${VERSION}/* ${NIFI_HOME} && \
        rm -rf ${NIFI_HOME}/nifi-${VERSION} && \
        rm -rf *.zip && \
        apk del curl && \
        rm -rf /var/cache/apk/*

COPY    docker-entrypoint.sh /


WORKDIR ${NIFI_HOME}

EXPOSE 8080 8081 8443

ENTRYPOINT      ["/docker-entrypoint.sh"]
CMD             ["/opt/nifi/bin/nifi.sh", "run"]
