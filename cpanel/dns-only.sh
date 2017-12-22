#!/bin/bash


yum update -y
yum upgrade -y
yum -y remove mlocate
yum install -y nmap wget curl telnet whois net-tools git vim tmux strace sysstat lsof

wget http://layer1.cpanel.net/cpanel-dnsonly-install.sea
sh cpanel-dnsonly-install.sea