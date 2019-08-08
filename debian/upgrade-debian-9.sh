#!/bin/bash

apt update && apt upgrade -y && apt dist-upgrade -y

mv /etc/apt/sources.list /etc/apt/sources.list.serverok-debian-9

cat << EOF >> /etc/apt/sources.list

deb http://cloudfront.debian.net/debian/ buster main non-free contrib
deb-src http://cloudfront.debian.net/debian/ buster main non-free contrib

deb http://security.debian.org/debian-security buster/updates main contrib non-free
deb-src http://security.debian.org/debian-security buster/updates main contrib non-free

EOF

apt update && apt upgrade -y

apt dist-upgrade -y
