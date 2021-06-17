To setup nginx/php74 on Ubuntu 20.04 

ansible-playbook -i servers.txt setup.yaml 

phpMyAdmin install on nginx debian/Ubuntu

ansible-playbook -i servers.txt phpmyadmin.yaml 

ansible-playbook -i inventory/cpanel-servers.txt update-cpanel-servers.yml

ansible-playbook -i servers.txt --ask-pass phpmyadmin-apache.yaml 

ansible all -u root -i servers.txt -a "systemctl restart php7.4-fpm"

