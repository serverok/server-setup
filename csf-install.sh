#!/bin/bash

# apt -y install libwww-perl
# yum install -y perl perl-libwww-perl perl-Time-HiRes unzip bind-utils

cd /usr/local/src
wget https://download.configserver.com/csf.tgz
tar -xzf csf.tgz
cd csf
sh install.sh
