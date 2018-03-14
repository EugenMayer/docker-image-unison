FROM alpine:edge

ARG UNISON_VERSION=2.51.2
RUN apk add --no-cache build-base curl bash monit supervisor inotify-tools rsync ruby\
    && apk add --update-cache --repository http://dl-4.alpinelinux.org/alpine/edge/testing/ ocaml \
    && curl -L https://github.com/bcpierce00/unison/archive/v$UNISON_VERSION.tar.gz | tar zxv -C /tmp \
    && cd /tmp/unison-${UNISON_VERSION} \
    && sed -i -e 's/GLIBC_SUPPORT_INOTIFY 0/GLIBC_SUPPORT_INOTIFY 1/' src/fsmonitor/linux/inotify_stubs.c \
    && make UISTYLE=text NATIVE=true STATIC=true \
    && cp src/unison src/unison-fsmonitor /usr/local/bin \
    && apk del curl build-base ocaml \
    && apk add --no-cache libgcc libstdc++ \
    && rm -rf /tmp/unison-${UNISON_VERSION} \
    && apk add --no-cache --repository http://dl-4.alpinelinux.org/alpine/edge/testing/ shadow \
 	&& apk add --no-cache tzdata

############# ############# #############
############# SHARED        #############
############# ############# #############

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
