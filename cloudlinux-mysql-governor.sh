#!/bin/bash
# Author: ServerOK.in
# Email: admin@serverok.in
# Web; https://www.serverok.in

yum install -y governor-mysql
/usr/share/lve/dbgovernor/mysqlgovernor.py --install

