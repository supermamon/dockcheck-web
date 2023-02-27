#!/bin/bash
while inotifywait -e modify /var/www/html/update.txt; do
    echo "* $0 update trigerred."
    run-parts /etc/cron.daily/
    echo 0 > /var/www/html/update.txt
done
root