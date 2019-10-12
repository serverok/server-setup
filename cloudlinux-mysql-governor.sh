#!/bin/bash
# Author: ServerOK.in
# Email: admin@serverok.in
# Web; https://www.serverok.in

yum install -y governor-mysql
/usr/share/lve/dbgovernor/mysqlgovernor.py --install

/usr/share/lve/dbgovernor/mysqlgovernor.py --mysql-version=mariadb103
/usr/share/lve/dbgovernor/mysqlgovernor.py --install
