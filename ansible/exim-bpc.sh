#!/bin/bash

cd /home/boby/www/projects/server-setup/ansible
ansible cpanel -i ansible.hosts -a "exim -bpc"

