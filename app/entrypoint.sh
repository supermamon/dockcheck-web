#!/bin/sh
echo "* $0 starting dockcheck-web"

if [ "$NOTIFY" = "true" ]; then
    if [ -n "$NOTIFY_URLS" ]; then
        echo $NOTIFY_URLS > /app/NOTIFY_URLS
        echo "* $0 notifications activated"
    fi

    if [ "$NOTIFY_DEBUG" = "true" ]; then
        echo $NOTIFY_DEBUG > /app/NOTIFY_DEBUG
        echo "$0 NOTIFY DEBUGMODE ACTIVATED"
        
    fi
fi


if [ "$CHECK_ON_LAUNCH" = "true" ]; then
    echo "* $0 running dockcheck"
    run-parts /etc/cron.daily/
else
    echo "* $0 skipping dockcheck on launch"
fi

echo "* $0 setting up web app"
chown www-data:www-data /var/www/html/*
chown www-data:www-data /data
chmod 777 /data
[ -f "/data/containers" ] || echo '0' > /data/containers
[ -f "/data/containers" ] && chown www-data:www-data /data/*
[ -f "/data/containers" ] && chmod 777 /data/*

echo "* $0 running watcher"
/app/watcher.sh & #</dev/null >/dev/null 2>&1 &

echo "* $0 starting web server"
echo "ServerName localhost" >> /etc/apache2/apache2.conf
exec apache2-foreground