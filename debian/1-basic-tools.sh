#!/bin/bash

apt update
apt -y upgrade
apt -y install wget curl nmap whois vim screen git unzip atop htop telnet net-tools
apt -y purge mlocate
