#!/bin/bash

/bin/sed -i "s/RESTRICT_SYSLOG\s*=.*$/RESTRICT_SYSLOG = \"3\"/g" /etc/csf/csf.conf
/bin/sed -i "s/SYSLOG_CHECK\s*=.*$/SYSLOG_CHECK = \"3600\"/g" /etc/csf/csf.conf

# By default, CSF will block allowed IP if they break rules.
/bin/sed -i "s/IGNORE_ALLOW\s*=.*/IGNORE_ALLOW = \"1\"/g" /etc/csf/csf.conf


#/bin/sed -i "s/LF_GLOBAL\s*=.*$/LF_GLOBAL = \"1800\"/g" /etc/csf/csf.conf
#/bin/sed -i "s/GLOBAL_ALLOW\s*=.*$/GLOBAL_ALLOW = \"http:\/\/git\.buyscripts\.in\:10080\/boby\/firewall\/raw\/master\/allow\.txt\"/g" /etc/csf/csf.conf
#/bin/sed -i "s/GLOBAL_DENY\s*=.*$/GLOBAL_DENY = \"http\:\/\/git\.buyscripts\.in\:10080\/boby\/firewall\/raw\/master\/deny.txt\"/g" /etc/csf/csf.conf

# This option will notify you when a large amount of email is sent from a particular script on the server
/bin/sed -i "s/LF_SCRIPT_ALERT\s*=.*$/LF_SCRIPT_ALERT = \"1\"/g" /etc/csf/csf.conf

# This option ensures that almost all Linux accounts are checked with Process Tracking, not just the cPanel ones
/bin/sed -i "s/PT_ALL_USERS\s*=.*$/PT_ALL_USERS = \"1\"/g" /etc/csf/csf.conf


/bin/sed -i "s/TESTING = \"1\"/TESTING = \"0\"/g" /etc/csf/csf.conf

# Disable IP blocking alert. You may get many, if you dont need to act on this, disable it

/bin/sed -i "s/PT_USERMEM\s*=.*/PT_USERMEM = \"1024\"/g" /etc/csf/csf.conf
/bin/sed -i "s/LF_NETBLOCK_ALERT\s*=.*/LF_NETBLOCK_ALERT = \"0\"/g" /etc/csf/csf.conf
/bin/sed -i "s/LF_PERMBLOCK_ALERT\s*=.*/LF_PERMBLOCK_ALERT = \"0\"/g" /etc/csf/csf.conf

# Disable all alerts
# /bin/sed -i "s/LF_EMAIL_ALERT\s*=.*/LF_EMAIL_ALERT = \"0\"/g" /etc/csf/csf.conf

# ONLY CPANEL

if [ -d "/var/cpanel/" ]; then
    /bin/sed -i "s/SMTP_BLOCK\s*=.*/SMTP_BLOCK = \"1\"/g" /etc/csf/csf.conf
fi

# /bin/sed -i "s/LF_ALERT_TO\s*=.*$/LF_ALERT_TO = \"admin@serverok.in\"/g" /etc/csf/csf.conf

systemctl restart csf.service
csf -r

