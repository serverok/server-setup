#!/bin/bash

yum install -y governor-mysql
/usr/share/lve/dbgovernor/mysqlgovernor.py --install

