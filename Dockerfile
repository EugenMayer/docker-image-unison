FROM alpine:edge

ARG UNISON_VERSION=2.51.2

RUN apk update \
    && apk add --no-cache --repository="http://dl-cdn.alpinelinux.org/alpine/v3.10/main" binutils=2.32-r0 \
    && apk add --no-cache --virtual .build-deps \
        build-base curl git ocaml=4.08.1-r0 \
    && apk add --no-cache \
        bash inotify-tools monit supervisor rsync ruby \
    && curl -L https://github.com/bcpierce00/unison/archive/v$UNISON_VERSION.tar.gz | tar zxv -C /tmp \
    && cd /tmp/unison-${UNISON_VERSION} \
    && curl https://github.com/bcpierce00/unison/commit/23fa1292.diff?full_index=1 -o patch.diff \
    && git apply patch.diff \
    && rm patch.diff \
    && sed -i -e 's/GLIBC_SUPPORT_INOTIFY 0/GLIBC_SUPPORT_INOTIFY 1/' src/fsmonitor/linux/inotify_stubs.c \
    && make UISTYLE=text NATIVE=true STATIC=true \
    && cp src/unison src/unison-fsmonitor /usr/local/bin \
    && apk del binutils .build-deps  \
    && apk add --no-cache libgcc libstdc++ \
    && rm -rf /tmp/unison-${UNISON_VERSION} \
    && apk add --no-cache --repository http://dl-4.alpinelinux.org/alpine/edge/testing/ shadow \
    && apk add --no-cache tzdata

# These can be overridden later
ENV TZ="Europe/Helsinki" \
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
 && touch /tmp/unison.log \
 && chmod u=rw,g=rw,o=rw /tmp/unison.log \
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