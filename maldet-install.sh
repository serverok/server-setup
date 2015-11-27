#!/bin/bash

# https://blog.hostonnet.com/maldet

cd /usr/local/src
wget http://www.rfxn.com/downloads/maldetect-current.tar.gz
tar zxvf maldetect-current.tar.gz
cd maldetect-*
./install.sh

# Download config
cd /usr/local/maldetect/
rm -f conf.maldet
wget https://github.com/HostOnNet/server-setup/raw/master/data/conf.maldet

