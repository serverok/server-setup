#!/bin/bash

mkdir /root/cpanel3-skel/
echo "archive-logs=1" > /root/cpanel3-skel/.cpanel-logs
echo "remove-old-archived-logs=1" >> /root/cpanel3-skel/.cpanel-logs

# disable mail from mailer-daemon
/bin/sed -i "s/mailer-daemon:\tpostmaster/mailer-daemon: \/dev\/null/g" /etc/aliases

# Copy EasyApache3 Profile
rm -f /var/cpanel/easy/apache/profile/custom/hostonnet.yaml
/bin/cp data/hostonnet.yaml /var/cpanel/easy/apache/profile/custom/hostonnet.yaml

# Copy cpanel settings
rm -f /var/cpanel/cpanel.config
cp data/cpanel.config /var/cpanel/
/usr/local/cpanel/whostmgr/bin/whostmgr2 -updatetweaksettings

