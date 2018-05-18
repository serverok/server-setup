#!/bin/bash

# Author: admin@serverok.in
# Web: https://www.serverok.in/enable-dkim-on-cpanel-server

for username in `ls -A /var/cpanel/users`; do
    echo "Installing DKIM and SPF for $username"
    /usr/local/cpanel/bin/dkim_keys_install $username
    /usr/local/cpanel/bin/spf_installer $username
done
