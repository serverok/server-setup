#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in

echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list

cd /root
wget http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc

apt update
apt -y install apt-transport-https 
apt -y install webmin
