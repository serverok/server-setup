#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in

apt update
apt -y upgrade
apt -y install wget curl nmap whois vim screen git unzip atop htop telnet tmux
apt install -y software-properties-common
apt -y purge mlocate
apt autoremove -y

systemctl stop apparmor
systemctl disable apparmor

curl -Ls https://github.com/serverok/server-setup/raw/master/data/.vimrc > ~/.vimrc
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc

rm -f /etc/update-motd.d/*
