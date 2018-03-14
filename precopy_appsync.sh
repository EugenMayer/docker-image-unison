#!/bin/sh

APP_VOLUME=${APP_VOLUME:-/app_sync}
HOST_VOLUME=${HOST_VOLUME:-/host_sync}
OWNER_UID=${OWNER_UID:-0}

if [ ! -f /unison/initial_sync_finished ]; then
	echo "doing initial sync with unison"
	# we use ruby due to http://mywiki.wooledge.org/BashFAQ/050
	time ruby -e '`unison #{ENV["UNISON_ARGS"]} #{ENV["UNISON_SYNC_PREFER"]} #{ENV["UNISON_EXCLUDES"]} -numericids -auto -batch /host_sync /app_sync`'
	#time cp -au  $HOST_VOLUME/.  $APP_VOLUME
	echo "chown ing file to uid $OWNER_UID"
	chown -R ${OWNER_UID} ${APP_VOLUME}
	touch /unison/initial_sync_finished
	echo "initial sync done using unison" >> /tmp/unison.log
else
	echo "skipping initial copy with unison"
fi
