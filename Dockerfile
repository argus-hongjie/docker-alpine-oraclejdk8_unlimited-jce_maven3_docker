FROM frolvlad/alpine-oraclejdk8:slim

MAINTAINER Scott Fan <fancp2007@gmail.com>

ENV MAVEN_VERSION 3.3.9

ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.11.2
ENV DOCKER_SHA256 8c2e0c35e3cda11706f54b2d46c2521a6e9026a7b13c7d4b8ae1f3a706fc55e1

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
