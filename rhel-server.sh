#!/bin/bash

echo "Updating system...."

yum update

yum upgrade -y

/bin/sed -i "s/#Port 22/Port 3333/g" /etc/ssh/sshd_config
/bin/sed -i "s/#Protocol 2/Protocol 2/g" /etc/ssh/sshd_config
service sshd restart

yum -y remove mlocate

echo "Installing basic system tools"

yum install -y nmap lynx wget curl telnet screen jwhois
yum install -y atop iotop
yum install -y strace
yum install -y git
yum install -y sysstat

echo "Installing build tools"

yum install -y ncurses-devel automake autoconf gcc gmake patch make
yum install -y libcpp libgcc libstdc++ gcc4 gcc4-c++ gcc4-gfortran
yum install -y dos2unix libtool gcc-c++ gcc-c++ compat-gcc-32 compat-gcc-32-c++

