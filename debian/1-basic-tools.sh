#!/bin/bash

apt update
apt -y upgrade
apt -y install wget curl nmap whois vim screen git unzip atop htop telnet net-tools dnsutils tmux iftop

echo "set mouse-=a" >> ~/.vimrc
echo "alias ll='ls -la --color'" >> ~/.bashrc
echo "alias rm='rm -i'" >> ~/.bashrc
echo "alias grep='grep --color=auto'" >> ~/.bashrc
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc

source ~/.bashrc
