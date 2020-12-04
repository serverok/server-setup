#!/bin/bash
################################################################################
# Author: ServerOK
# Web: https://serverok.in/mysql-restart-bash
################################################################################
# mkdir /usr/serverok
# vi /usr/serverok/mysql_monitor.sh
# chmod 755 /usr/serverok/mysql_monitor.sh
# crontab -e
# */5 * * * * /usr/serverok/mysql_monitor.sh > /var/log/sok-mysql.log
################################################################################

MYSQL_USER="root"
MYSQL_PASSWORD="YOUR_ROOT_PW_HERE"

################################################################################
# DO NOT EDIT BELOW
################################################################################

MYSQL_REPLY="$(mysqladmin -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ping)"
TIME_STAMP="$(date "+%Y-%m-%d %H:%M:%S")"

if [[ ! "$MYSQL_REPLY" =~ "mysqld is alive" ]]
then
    systemctl restart mariadb
    echo -e "${TIME_STAMP} MySQL Down\n"
fi
