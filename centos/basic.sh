#!/bin/bash

# wget https://raw.githubusercontent.com/serverok/server-setup/master/centos/basic.sh && chmod 755 basic.sh && ./basic.sh

yum -y upgrade
yum -y remove mlocate
yum install -y nmap wget curl telnet whois bind-utils net-tools parted
yum install -y iotop
yum install -y git vim tmux
yum install -y strace sysstat lsof lbzip2
yum install -y ncurses-devel automake autoconf gcc gmake patch make
yum install -y libcpp libgcc libstdc++ gcc4 gcc4-c++ gcc4-gfortran
yum install -y dos2unix libtool gcc-c++ gcc-c++ compat-gcc-32 compat-gcc-32-c++
yum groupinstall -y "Development tools"

/bin/sed -i "s/#UseDNS yes/UseDNS no/g" /etc/ssh/sshd_config

echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc