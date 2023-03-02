#!/bin/bash
while inotifywait -q -e modify /var/www/html/update.txt; do
    echo "* $0 update trigerred."
    run-parts /etc/cron.daily/
    [ -f "/data/running" ] && rm /data/running
    echo 0 > /var/www/html/update.txt
done
root