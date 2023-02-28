FROM php:8.1-rc-apache
LABEL maintainer="dev@supermamon.com"
LABEL description="Image updates for your running containers"
LABEL url="https://github.com/supermamon/dockcheck-web"

ARG ARCH

WORKDIR /app

RUN apt update && apt install cron docker.io inotify-tools pip -y \
&& curl -sL "https://raw.githubusercontent.com/mag37/dockcheck/main/dc_brief.sh" -o /app/dockcheck.sh \
&& rm -rf /etc/cron.daily/* \
&& mkdir -p /var/www/tmp \
&& mkdir -p /var/www/html \
&& curl -sL "https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css" -o /var/www/html/bulma.min.css \
&& pip install apprise \
&& chmod +x /app/dockcheck.sh

RUN case ${ARCH} in \
         "linux/amd64")  os=amd64  ;; \
         "linux/arm64")  os=arm64  ;; \
    esac \
&& curl -sL "https://github.com/regclient/regclient/releases/download/v0.4.5/regctl-linux-${os}" -o /usr/bin/regctl \
&& chmod +x /usr/bin/regctl

ENV NOTIFY="" \
NOTIFY_DEBUG="" \
NOTIFY_URLS="" \
EXCLUDE="" \
CHECK_ON_LAUNCH="true"

COPY app* /app/
COPY app/src /var/www/html/

VOLUME /data

RUN cp /app/cron/dockcheck /etc/cron.daily/dockcheck \
&& chmod +x /etc/cron.daily/dockcheck \
&& rm -rf /etc/crontab \
&& cp /app/cron/crontab /etc/crontab \
&& service cron start \
&& chmod +x /app/watcher.sh \
&& mkdir /data \
&& echo "0" > /data/containers

ENTRYPOINT ["/app/entrypoint.sh", "env"]