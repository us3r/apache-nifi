FROM openjdk:8-alpine

MAINTAINER Mariusz Derela <mariusz.derela@gmail.com>

# Environment variables
ENV     NIFI_HOME   /opt/nifi

# ARGS
ARG     DIST_MIRROR=http://mirror.cc.columbia.edu/pub/software/apache/nifi
ARG     VERSION=1.1.1

# Create Environment, install depedencies

RUN     apk update && apk add --upgrade bash curl && \
        bash -c "mkdir -p $NIFI_HOME/{database_repositories,flowfile_repositories,content_repostory,provenance_repository}" && \
        curl ${DIST_MIRROR}/${VERSION}/nifi-${VERSION}-bin.tar.gz | tar xvz -C ${NIFI_HOME} && \
        mv ${NIFI_HOME}/nifi-${VERSION}/* ${NIFI_HOME} && \
        rm -rf ${NIFI_HOME}/nifi-${VERSION} && \
        rm -rf *.tar.gz && \
        apk del curl && \
        rm -rf /var/cache/apk/*

COPY    docker-entrypoint.sh /


VOLUME  ["${NIFI_HOME}/logs","${NIFI_HOME}/flowfile_repositories","${NIFI_HOME}/content_repostory","${NIFI_HOME}/provenance_repository","${NIFI_HOME}/database_repositories"]

WORKDIR ${NIFI_HOME}

ENTRYPOINT      ["/docker-entrypoint.sh"]
CMD             ["/opt/nifi/bin/nifi.sh", "run"]
