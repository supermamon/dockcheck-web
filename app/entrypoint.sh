#!/bin/sh


export -p > /app/ENV

[ "$DEBUG" = "true" ] && echo "*** DEBUGGING IS ACTIVATED ***" 

echo "* $0 starting dockcheck-web"

if [ "$NOTIFY" = "true" ]; then
    [ -n "$NOTIFY_URLS" ] && echo "* $0 notifications activated"
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

mkdir -p /data/logs || true

echo "* $0 starting crontab"
if [ "$DEBUG" = "true" ]; then
    echo "* DEBUG: $0 adding crontest to cron"
    echo "  *  *  *  *  * root    /app/crontest.sh" >> /etc/crontab
    service cron start
else
    service cron start >/dev/null  2>&1 &
fi  

echo "* $0 running watcher"
/app/watcher.sh & #</dev/null >/dev/null 2>&1 &

echo "* $0 starting web server"
if [ "$SILENCE_APACHE_LOGS" = "true" ]; then
  ln -fs /dev/null /var/log/apache2/access.log
fi
echo "ServerName localhost" >> /etc/apache2/apache2.conf
exec apache2-foreground