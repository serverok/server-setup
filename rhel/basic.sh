#!/bin/bash

yum update -y
yum upgrade -y
yum -y remove mlocate
yum install -y nmap lynx wget curl telnet whois bind-utils
yum install -y atop iotop
yum install -y strace
yum install -y git
yum install -y lsof
yum install -y sysstat
yum install -y vim
yum install -y tmux
yum install -y ncurses-devel automake autoconf gcc gmake patch make
yum install -y libcpp libgcc libstdc++ gcc4 gcc4-c++ gcc4-gfortran
yum install -y dos2unix libtool gcc-c++ gcc-c++ compat-gcc-32 compat-gcc-32-c++

# Copy .vimrc if not exists
if ! [ -f /root/.vimrc ] ; then
    cp ../data/.vimrc /root/.vimrc
fi

if ! grep .bash_hostonnet /root/.bashrc; then
    echo "source /root/.bash_hostonnet" >> /root/.bashrc
fi

if ! [ -f /root/.bash_hostonnet ]; then
    cp ../data/.bash_hostonnet /root/.bash_hostonnet
fi
