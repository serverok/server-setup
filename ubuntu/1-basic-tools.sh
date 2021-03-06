#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in

apt update
apt -y upgrade
apt -y install procps wget curl nmap whois vim git unzip telnet tmux
apt install -y net-tools
apt install -y software-properties-common
apt -y purge mlocate
apt remove -y vim-tiny nano ed --purge
apt autoremove -y

apt-get install -y sysstat
sed -i 's/ENABLED="false"/ENABLED="true"/g' /etc/default/sysstat

systemctl stop apparmor
systemctl disable apparmor

curl -Ls https://github.com/serverok/server-setup/raw/master/data/.vimrc > ~/.vimrc
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc

rm -f /etc/update-motd.d/*
