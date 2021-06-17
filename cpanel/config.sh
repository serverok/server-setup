#!/bin/bash
# Author: ServerOK.in
# Email: admin@serverok.in
# Web; https://www.serverok.in

# WHM Tweaks for better CSF score

# Disable SMTP Restrictions. WHM > Security Center > SMTP Restrictions
/bin/sed -i "s/^smtpmailgidonly=1$/smtpmailgidonly=0/g" /var/cpanel/cpanel.config

# Check cPanel login is SSL only. WHM > Tweak Settings > Always redirect to SSL
# /bin/sed -i "s/^alwaysredirecttossl=0$/alwaysredirecttossl=1/g" /var/cpanel/cpanel.config

# Check BoxTrapper is disabled in WHM > Tweak Settings > BoxTrapper spam trap
/bin/sed -i "s/^skipboxtrapper=0$/skipboxtrapper=1/g" /var/cpanel/cpanel.config

# Max hourly emails per domain. WHM > Tweak Settings > Max hourly emails per domain
/bin/sed -i "s/^maxemailsperhour.*$/maxemailsperhour=500/g" /var/cpanel/cpanel.config

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

# Initial default/catch-all forwarder destination
/bin/sed -i "s/^defaultmailaction=.*$/defaultmailaction=blackhole/g" /var/cpanel/cpanel.config

# set timezone to UTC

rm -f /etc/localtime
ln -s /usr/share/zoneinfo/UTC /etc/localtime

# enable only awstats

echo "DEFAULTGENS=AWSTATS" > /etc/stats.conf
echo "allow_awstats_include=0" >> /etc/stats.conf

/bin/sed -i "s/^skipanalog=0/skipanalog=1/g" /var/cpanel/cpanel.config
/bin/sed -i "s/^skipwebalizer=0/skipwebalizer=1/g" /var/cpanel/cpanel.config

/scripts/initquotas

# Keep cpanel logs

mkdir /root/cpanel3-skel/
echo "archive-logs=1" > /root/cpanel3-skel/.cpanel-logs
echo "remove-old-archived-logs=1" >> /root/cpanel3-skel/.cpanel-logs

# disable mail from mailer-daemon

/bin/sed -i "s/mailer-daemon:\tpostmaster/mailer-daemon: \/dev\/null/g" /etc/aliases

# install clamav

/scripts/update_local_rpm_versions --edit target_settings.clamav installed
/scripts/check_cpanel_rpms --fix --targets=clamav

service cpanel restart

# Enable shell bomb protection

/usr/local/cpanel/bin/install-login-profile --install limits

ln -s /scripts/whoowns /usr/local/bin/whoowns

/bin/systemctl stop rpcbind
/bin/systemctl disable rpcbind
