#!/bin/bash

cd /usr/local/src
wget http://www.configserver.com/free/csf.tgz
tar -xzf csf.tgz
cd csf
sh install.sh

rm -f /etc/csf/csf.conf
cd /etc/csf
wget https://github.com/HostOnNet/server-setup/raw/master/data/csf.conf
csf -r

