#!/bin/bash

/bin/sed -i "s/RESTRICT_SYSLOG\s*=.*$/RESTRICT_SYSLOG = \"3\"/g" /etc/csf/csf.conf
/bin/sed -i "s/SYSLOG_CHECK\s*=.*$/SYSLOG_CHECK = \"3600\"/g" /etc/csf/csf.conf
/bin/sed -i "s/SMTP_BLOCK\s*=.*/SMTP_BLOCK = \"1\"/g" /etc/csf/csf.conf

/bin/sed -i "s/LF_GLOBAL\s*=.*$/LF_GLOBAL = \"1800\"/g" /etc/csf/csf.conf
/bin/sed -i "s/GLOBAL_ALLOW\s*=.*$/GLOBAL_ALLOW = \"http:\/\/git\.buyscripts\.in\:10080\/boby\/firewall\/raw\/master\/allow\.txt\"/g" /etc/csf/csf.conf
/bin/sed -i "s/GLOBAL_DENY\s*=.*$/GLOBAL_DENY = \"http\:\/\/git\.buyscripts\.in\:10080\/boby\/firewall\/raw\/master\/deny.txt\"/g" /etc/csf/csf.conf

# This option will notify you when a large amount of email is sent from a particular script on the server
/bin/sed -i "s/LF_SCRIPT_ALERT\s*=.*$/LF_SCRIPT_ALERT = \"1\"/g" /etc/csf/csf.conf

# This option ensures that almost all Linux accounts are checked with Process Tracking, not just the cPanel ones
/bin/sed -i "s/PT_ALL_USERS\s*=.*$/PT_ALL_USERS = \"1\"/g" /etc/csf/csf.conf


/bin/sed -i "s/TESTING = \"1\"/TESTING = \"0\"/g" /etc/csf/csf.conf


/bin/systemctl restart csf.service
csf -r
