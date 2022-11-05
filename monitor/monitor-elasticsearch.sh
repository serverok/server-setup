#!/bin/bash
# Author: ServerOK
# Web: https://serverok.in/how-to-auto-restart-elasticsearch-on-failure
# Auto restart ElasticSearch on crash.
# chmod 755 /usr/serverok/elasticsearch.sh
# */5 * * * * /usr/serverok/elasticsearch.sh >> /var/log/sok-elasticsearch.log

TIME_STAMP="$(date "+%Y-%m-%d %H:%M:%S")"
CMD_RESULT="$(ps -ef | grep -v grep | grep elastic)"

if [[ -z $CMD_RESULT ]];
then
    systemctl restart elasticsearch
    echo -e "${TIME_STAMP} ElasticSearch restarted\n"
fi
