#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in

apt update
apt -y upgrade
apt -y install wget curl nmap whois vim screen git unzip atop htop telnet
apt -y purge mlocate
apt autoremove -y
