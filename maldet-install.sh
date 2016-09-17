#!/bin/bash

# https://blog.hostonnet.com/maldet

cd /usr/local/src
wget http://www.rfxn.com/downloads/maldetect-current.tar.gz
tar zxvf maldetect-current.tar.gz
cd maldetect-*
./install.sh

# edit config file at /usr/local/maldetect/conf.maldet
# email_alert="0"
# email_addr="you@domain.com"

