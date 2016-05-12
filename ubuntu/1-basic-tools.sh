#!/bin/bash

# https://blog.hostonnet.com/ubuntu-14-04-openvz-locale-cannot-set-lc_all-to-default-locale-no-such-file-or-directory
echo "LC_ALL=en_US.UTF-8" >> /etc/environment
echo "LANG=en_US.UTF-8" >> /etc/environment
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

apt-get update
apt-get -y upgrade
apt-get -y install wget curl nmap whois vim screen git
apt-get -y purge mlocate
