ARG BASE_IMAGE=alpine:3.12
FROM $BASE_IMAGE

ARG OCAML_VERSION=4.12.0
ARG UNISON_VERSION=2.52.1

RUN echo "OCAL VERSION: ${OCAML_VERSION}"
RUN echo "UNISON VERSION: ${UNISON_VERSION}"

RUN apk update \
    && apk add --no-cache --virtual .build-deps build-base curl git build-base coreutils \
    && curl -L http://caml.inria.fr/pub/distrib/ocaml-${OCAML_VERSION:0:4}/ocaml-${OCAML_VERSION}.tar.gz --output -  | tar zxv -C /tmp \
    && cd /tmp/ocaml-${OCAML_VERSION} \
    && ./configure \
    && make world \
    && make opt \
    && umask 022 \
    && make install \
    && make clean \
    && apk del .build-deps  \
    && rm -rf /tmp/ocaml-${OCAML_VERSION}

RUN apk update \
    && apk add --no-cache --virtual .build-deps build-base curl git build-base coreutils \
    && apk add --no-cache \
    bash inotify-tools monit supervisor rsync ruby \
    && curl -L https://github.com/bcpierce00/unison/archive/v$UNISON_VERSION.tar.gz --output - | tar zxv -C /tmp \
    && cd /tmp/unison-${UNISON_VERSION} \
    && sed -i -e 's/GLIBC_SUPPORT_INOTIFY 0/GLIBC_SUPPORT_INOTIFY 1/' src/fsmonitor/linux/inotify_stubs.c \
    && make UISTYLE=text NATIVE=true STATIC=true \
    && cp src/unison src/unison-fsmonitor /usr/local/bin \
    && apk del binutils .build-deps  \
    && apk add --no-cache libgcc libstdc++ \
    && rm -rf /tmp/unison-${UNISON_VERSION} \
    && apk add --no-cache --repository http://dl-4.alpinelinux.org/alpine/v3.12/testing/ shadow \
    && apk add --no-cache tzdata

# These can be overridden later
ENV TZ="Europe/Berlin" \
    LANG="C.UTF-8" \
    UNISON_DIR="/data" \
    HOME="/root"

COPY entrypoint.sh /entrypoint.sh
COPY precopy_appsync.sh /usr/local/bin/precopy_appsync
COPY monitrc /etc/monitrc

RUN mkdir -p /docker-entrypoint.d \
    && chmod +x /entrypoint.sh \
    && mkdir -p /etc/supervisor.conf.d \
    && mkdir /unison \
    && chmod +x /usr/local/bin/precopy_appsync \
    && chmod u=rw,g=,o= /etc/monitrc

COPY supervisord.conf /etc/supervisord.conf
COPY supervisor.daemon.conf /etc/supervisor.conf.d/supervisor.daemon.conf

ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord"]
############# ############# #############
############# /SHARED     / #############
############# ############# #############

VOLUME /unison
EXPOSE 5000
