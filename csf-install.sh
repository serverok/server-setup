#!/bin/bash

cd /usr/local/src
wget https://download.configserver.com/csf.tgz
tar -xzf csf.tgz
cd csf
sh install.sh
