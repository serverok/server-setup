#!/bin/bash

# https://blog.hostonnet.com/ubuntu-14-04-openvz-locale-cannot-set-lc_all-to-default-locale-no-such-file-or-directory

apt update
apt -y upgrade
apt -y install wget curl nmap whois vim screen git unzip atop htop telnet
apt -y purge mlocate
apt autoremove -y