#!/bin/bash

source /opt/.env

id -u ${USER} &>/dev/null || useradd --create-home --shell /bin/bash --user-group --groups adm,sudo ${USER}
echo "${USER}:${PASS}" | chpasswd

sed -i "s/ubuntu/${USER}/g" /etc/supervisor/conf.d/*
rm -f /opt/.env
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
