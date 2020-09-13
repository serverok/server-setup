DOMAIN_NAME
USERNAME
MYSQL_PASSWORD
admin@serverok.in

------------------

sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
service ssh restart

dd if=/dev/zero of=/swapfile bs=1M count=2048
chmod 0600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

useradd -m --shell /bin/bash --home /home/DOMAIN_NAME USERNAME
passwd USERNAME

vi /etc/httpd/conf.d/DOMAIN_NAME.conf

<VirtualHost *:80>
    ServerName DOMAIN_NAME
    ServerAlias www.DOMAIN_NAME
    ServerAdmin info@DOMAIN_NAME
    DocumentRoot /home/DOMAIN_NAME/html
    <Directory "/home/DOMAIN_NAME/html">
        Options All
        AllowOverride All
        Require all granted
        Order allow,deny
        allow from all
    </Directory>
</VirtualHost>

sed -i "s/User apache/User USERNAME/g" /etc/httpd/conf/httpd.conf
sed -i "s/Group apache/Group USERNAME/g" /etc/httpd/conf/httpd.conf

chown -R USERNAME:USERNAME /var/lib/php/

mkdir /home/DOMAIN_NAME/html/

echo "<?php phpinfo();" > /home/DOMAIN_NAME/html/index.php
chown -R USERNAME:USERNAME /home/DOMAIN_NAME/
chmod -R 755 /home/DOMAIN_NAME/html/

mysql
create database USERNAME;
grant all on *.* to 'USERNAME'@'localhost' identified by 'MYSQL_PASSWORD';

systemctl restart httpd

curl http://DOMAIN_NAME

certbot --authenticator webroot --webroot-path /home/DOMAIN_NAME/html/ --installer apache --agree-tos --email admin@serverok.in -d DOMAIN_NAME -d www.DOMAIN_NAME