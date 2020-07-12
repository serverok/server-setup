apt install libapache2-mod-ruid2

DOMAIN_NAME
USERNAME
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
    <Directory "/home/DOMAIN_NAME/html">
        RMode config
        RUidGid USERNAME USERNAME
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
chmod -R 755 /home/DOMAIN_NAME/html/

mysql
create database USERNAME;
grant all on USERNAME.* to 'USERNAME'@'localhost' identified by 'MYSQL_PASSWORD';

GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' IDENTIFIED BY 'MYSQL_PASSWORD' WITH GRANT OPTION;
GRANT PROXY ON ''@'' TO 'admin'@'localhost' WITH GRANT OPTION;


systemctl restart apache2

certbot --authenticator webroot --webroot-path /home/DOMAIN_NAME/html/ --installer apache --agree-tos --no-eff-email --email admin@serverok.in -d DOMAIN_NAME -d www.DOMAIN_NAME