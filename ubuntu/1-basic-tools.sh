#!/bin/bash

# https://blog.hostonnet.com/ubuntu-14-04-openvz-locale-cannot-set-lc_all-to-default-locale-no-such-file-or-directory

apt-get update
apt-get -y upgrade
apt-get -y install wget curl nmap whois vim screen git
apt-get -y purge mlocate
