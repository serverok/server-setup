DOMAIN

yum -y install wget

wget https://raw.githubusercontent.com/serverok/server-setup/master/centos/basic.sh
bash basic.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/centos/selinux-disable.sh
bash selinux-disable.sh

curl -s k.serverok.in/k | bash

wget https://raw.githubusercontent.com/serverok/server-setup/master/install/letsencrypt.sh
sh ./letsencrypt.sh

mkdir -p /home/DOMAIN/html

vi /etc/httpd/conf.d/DOMAIN.conf

<VirtualHost *:80>
    ServerName DOMAIN
    ServerAlias www.DOMAIN
    DocumentRoot /home/DOMAIN/html/
    CustomLog /var/log/httpd/DOMAIN.log combined
    <Directory "/home/DOMAIN/html">
        Options All
        AllowOverride All
        Require all granted
        Order allow,deny
        allow from all
    </Directory>
</VirtualHost>

service httpd restart
