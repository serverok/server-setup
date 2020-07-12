#!/bin/bash

apt update
apt -y upgrade
apt -y install procps wget curl nmap whois vim git unzip telnet net-tools dnsutils tmux iftop
curl -Ls https://github.com/serverok/server-setup/raw/master/data/.vimrc > ~/.vimrc
echo "alias ll='ls -la --color'" >> ~/.bashrc
echo "alias rm='rm -i'" >> ~/.bashrc
echo "alias grep='grep --color=auto'" >> ~/.bashrc
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc

systemctl stop apparmor
systemctl disable apparmor

source ~/.bashrc
