#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in

export DEBIAN_FRONTEND=noninteractive

apt update
apt upgrade -y 
apt install -y procps wget curl nmap whois vim git unzip telnet tmux
apt install -y net-tools
apt install -y software-properties-common
apt purge -y mlocate
apt remove -y vim-tiny nano ed --purge
apt autoremove  --purge -y

apt install -y sysstat
sed -i 's/ENABLED="false"/ENABLED="true"/g' /etc/default/sysstat
systemctl enable sysstat.service sysstat-collect.timer
systemctl restart sysstat.service sysstat-collect.timer

systemctl status apparmor
systemctl stop apparmor
systemctl disable apparmor

curl -Ls https://github.com/serverok/server-setup/raw/master/data/.vimrc > ~/.vimrc
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc

rm -f /etc/update-motd.d/*
