#!/bin/bash

# WHM Tweaks for better CSF score

# Disable SMTP Restrictions. WHM > Security Center > SMTP Restrictions
/bin/sed -i "s/^smtpmailgidonly=1$/smtpmailgidonly=0/g" /var/cpanel/cpanel.config

# Check cPanel login is SSL only. WHM > Tweak Settings > Always redirect to SSL
# /bin/sed -i "s/^alwaysredirecttossl=0$/alwaysredirecttossl=1/g" /var/cpanel/cpanel.config

# Check BoxTrapper is disabled in WHM > Tweak Settings > BoxTrapper spam trap
/bin/sed -i "s/^skipboxtrapper=0$/skipboxtrapper=1/g" /var/cpanel/cpanel.config

# Max hourly emails per domain. WHM > Tweak Settings > Max hourly emails per domain
/bin/sed -i "s/^maxemailsperhour$/maxemailsperhour=150/g" /var/cpanel/cpanel.config

# Turn off Reset Password for cPanel accounts. WHM > Tweak Settings > Reset Password for cPanel accounts
/bin/sed -i "s/^resetpass=1$/resetpass=0/g" /var/cpanel/cpanel.config

# Turn off Reset Password for Subaccounts. WHM > Tweak Settings > Reset Password for Subaccounts
/bin/sed -i "s/^resetpass_sub=1$/resetpass_sub=0/g" /var/cpanel/cpanel.config

# Check proxy subdomains. WHM > Tweak Settings > Proxy subdomains
/bin/sed -i "s/^proxysubdomains=1$/proxysubdomains=0/g" /var/cpanel/cpanel.config

# Check accounts that can access a cPanel user. You should consider setting this option to "user" after use. WHM > Tweak Settings > Accounts that can access a cPanel user account
/bin/sed -i "s/^account_login_access=owner_root$/account_login_access=user/g" /var/cpanel/cpanel.config

# Enable Referrer Blank Security. WHM > Tweak Settings > Blank referrer safety check
/bin/sed -i "s/^referrerblanksafety=0$/referrerblanksafety=1/g" /var/cpanel/cpanel.config

# Enable Referrer Security. WHM > Tweak Settings > Referrer safety check
/bin/sed -i "s/^referrersafety=0$/referrersafety=1/g" /var/cpanel/cpanel.config

# Check Password ENV variable. WHM > Tweak Settings > Hide login password from cgi scripts
/bin/sed -i "s/^cgihidepass=0$/cgihidepass=1/g" /var/cpanel/cpanel.config

# set timezone to UTC

rm -f /etc/localtime
ln -s /usr/share/zoneinfo/UTC /etc/localtime

# enable only awstats

echo "DEFAULTGENS=AWSTATS" > /etc/stats.conf
echo "allow_awstats_include=0" >> /etc/stats.conf

service cpanel restart
