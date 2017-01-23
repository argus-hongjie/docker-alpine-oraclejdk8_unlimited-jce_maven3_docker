FROM frolvlad/alpine-oraclejdk8:slim

MAINTAINER Scott Fan <fancp2007@gmail.com>

ENV MAVEN_VERSION 3.3.9

ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.13.0
ENV DOCKER_SHA256 fc194bb95640b1396283e5b23b5ff9d1b69a5e418b5b3d774f303a7642162ad6

RUN apk upgrade --update && \
    apk add --update curl tar ca-certificates openssl && \
    mkdir -p /usr/share/maven && \
    curl -fsSL https://repo1.maven.org/maven2/org/apache/maven/apache-maven/$MAVEN_VERSION/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -xzC /usr/share/maven --strip-components=1 && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
    curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-$DOCKER_VERSION.tgz" -o docker.tgz && \
    echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - && \
    tar -xzvf docker.tgz && \
    mv docker/* /usr/local/bin/ && \
    rmdir docker && \
    rm docker.tgz && \
    docker -v && \
    apk del curl tar && \
    rm -rf /tmp/* /var/cache/apk/*

COPY docker-entrypoint.sh /usr/local/bin

ENV MAVEN_HOME /usr/share/maven

VOLUME /root/.m2

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["sh"]
