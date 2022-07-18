apt install libapache2-mod-ruid2
apt install libapache2-mpm-itk
a2enmod mpm_itk

SERVER_IP_HERE
DOMAIN_NAME
USERNAME
SFTP_PASSWORD
MYSQL_PASSWORD
admin@serverok.in

------------------

sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
service ssh restart

dd if=/dev/zero of=/swapfile bs=1M count=2048
mkswap /swapfile
chmod 0600 /swapfile
swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

useradd -m --shell /bin/bash --home /home/DOMAIN_NAME USERNAME
passwd USERNAME

SFTP_PASSWORD

vi /etc/apache2/sites-available/DOMAIN_NAME.conf

<VirtualHost *:80>
    ServerName DOMAIN_NAME
    ServerAlias www.DOMAIN_NAME
    ServerAdmin info@DOMAIN_NAME
    DocumentRoot /home/DOMAIN_NAME/html
    CustomLog ${APACHE_LOG_DIR}/DOMAIN_NAME.log combined
    ErrorLog ${APACHE_LOG_DIR}/DOMAIN_NAME-error.log
    #Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains"
    Header always append X-Frame-Options SAMEORIGIN
    <IfModule itk.c>
        AssignUserID USERNAME USERNAME
    </IfModule>
    <IfModule mod_ruid2.c>
        RMode config
        RUidGid USERNAME USERNAME
        RGroups www-data
    </IfModule>
    <Directory "/home/DOMAIN_NAME/html">
        Options All -Indexes
        AllowOverride All
        Require all granted
        Order allow,deny
        allow from all
    </Directory>
</VirtualHost>

a2ensite DOMAIN_NAME

mkdir /home/DOMAIN_NAME/html/
echo "<?php phpinfo();" > /home/DOMAIN_NAME/html/index.php
chown -R USERNAME:USERNAME /home/DOMAIN_NAME/
chmod -R 755 /home/DOMAIN_NAME/

mysql
create database USERNAME_db;
grant all on USERNAME_db.* to 'USERNAME_db'@'localhost' identified by 'MYSQL_PASSWORD';

GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' IDENTIFIED BY 'MYSQL_PASSWORD' WITH GRANT OPTION;
GRANT PROXY ON ''@'' TO 'admin'@'localhost' WITH GRANT OPTION;


systemctl restart apache2

certbot --authenticator webroot --webroot-path /home/DOMAIN_NAME/html/ --installer apache --agree-tos --no-eff-email --email admin@serverok.in -d DOMAIN_NAME -d www.DOMAIN_NAME


Server setup complete. Here is the login details.

SFTP

IP = SERVER_IP_HERE
Port = 22
User = USERNAME
PW = SFTP_PASSWORD

MySQL

DB = USERNAME_db
User = USERNAME_db
PW = MYSQL_PASSWORD

phpMyAdmin

http://SERVER_IP_HERE:7777

User = USERNAME_db
PW = MYSQL_PASSWORD

