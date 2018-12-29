#!/bin/bash
# Author: ServerOK.in
# Email: admin@serverok.in
# Web; https://www.serverok.in

mkdir /root/cpanel3-skel/
echo "archive-logs=1" > /root/cpanel3-skel/.cpanel-logs
echo "remove-old-archived-logs=1" >> /root/cpanel3-skel/.cpanel-logs

# disable mail from mailer-daemon
/bin/sed -i "s/mailer-daemon:\tpostmaster/mailer-daemon: \/dev\/null/g" /etc/aliases
