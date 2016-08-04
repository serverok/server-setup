#!/bin/bash

/bin/sed -i "s/RESTRICT_SYSLOG.*=.*/RESTRICT_SYSLOG = \"3\"/g" /etc/csf/csf.conf
/bin/sed -i "s/SYSLOG_CHECK.*=.*/SYSLOG_CHECK = \"3600\"/g" /etc/csf/csf.conf
/bin/sed -i "s/SMTP_BLOCK.*=.*/SMTP_BLOCK = \"1\"/g" /etc/csf/csf.conf
/bin/sed -i "s/SYNFLOOD_RATE.*=.*/SYNFLOOD_RATE = \"30\/s\"/g" /etc/csf/csf.conf
/bin/sed -i "s/SYNFLOOD_BURST.*=.*/SYNFLOOD_BURST = \"10\"/g" /etc/csf/csf.conf
/bin/sed -i "s/DROP_OUT_LOGGING.*=.*/DROP_OUT_LOGGING = \"0\"/g" /etc/csf/csf.conf
/bin/sed -i "s/LF_ALERT_TO.*=.*/LF_ALERT_TO = \"billing@hostonnet.com\"/g" /etc/csf/csf.conf
/bin/sed -i "s/LF_GLOBAL.*=.*/LF_GLOBAL = \"1800\"/g" /etc/csf/csf.conf
/bin/sed -i "s/GLOBAL_ALLOW.*=.*/GLOBAL_ALLOW = \"http:\/\/git\.buyscripts\.in\:10080\/boby\/firewall\/raw\/master\/allow\.txt\"/g" /etc/csf/csf.conf
/bin/sed -i "s/GLOBAL_DENY.*=.*/GLOBAL_DENY = \"http\:\/\/git\.buyscripts\.in\:10080\/boby\/firewall\/raw\/master\/deny.txt\"/g" /etc/csf/csf.conf
/bin/sed -i "s/LF_TRIGGER_PERM.*=.*/LF_TRIGGER_PERM = \"3600\"/g" /etc/csf/csf.conf

# csf -r