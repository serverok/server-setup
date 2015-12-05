#!/bin/bash


export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

apt-get update
apt-get -y upgrade
apt-get -y install wget curl nmap whois vim screen git

