#!/bin/bash

cd /home/boby/www/projects/server-setup/ansible
ansible cpanel -i inventory -a "uptime"

