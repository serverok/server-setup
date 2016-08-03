#!/bin/bash

WORK_DIR="$( pwd )"

cd /usr/local/src
wget http://www.configserver.com/free/csf.tgz
tar -xzf csf.tgz
cd csf
sh install.sh

rm -f /etc/csf/csf.conf
cp $WORK_DIR/data/csf.conf /etc/csf
csf -r
