#!/bin/bash

/bin/sed -i "s/#Port 22/Port 3333/g" /etc/ssh/sshd_config
/bin/sed -i "s/#Protocol 2/Protocol 2/g" /etc/ssh/sshd_config
/bin/sed -i "s/#UseDNS yes/UseDNS no/g" /etc/ssh/sshd_config

service sshd restart

