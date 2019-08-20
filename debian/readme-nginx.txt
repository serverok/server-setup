DOMAIN
USERNAME
PASSWORD_HERE
IP_ADDRESS_HERE

-------------------------------------------------------------------

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart ssh

useradd -m -d /home/DOMAIN/ -s /bin/bash USERNAME

passwd USERNAME

PASSWORD_HERE

cd /etc/php/7.3/fpm/pool.d/
curl -s https://raw.githubusercontent.com/serverok/server-setup/master/data/debian/php-fpm-pool.txt -o USERNAME.conf
sed -i 's/POOL_NAME/USERNAME/g' USERNAME.conf
sed -i 's/FPM_USER/USERNAME/g' USERNAME.conf

curl -s https://raw.githubusercontent.com/serverok/server-setup/master/data/debian/nginx-vhost.txt -o /etc/nginx/sites-available/DOMAIN.conf
sed -i 's/POOL_NAME/USERNAME/g' /etc/nginx/sites-available/DOMAIN.conf
sed -i 's/FQDN/DOMAIN/g' /etc/nginx/sites-available/DOMAIN.conf
ln -s /etc/nginx/sites-available/DOMAIN.conf /etc/nginx/sites-enabled/DOMAIN.conf


mkdir /home/DOMAIN/html/
chown -R USERNAME:USERNAME /home/DOMAIN/
chmod -R 755 /home/DOMAIN/

systemctl restart php7.3-fpm
systemctl restart nginx

http://www.DOMAIN/

certbot --authenticator webroot --webroot-path /home/DOMAIN/html/ --installer nginx -m admin@serverok.in --agree-tos --no-eff-email -d DOMAIN -d www.DOMAIN

sed -i 's/#systemctl restart nginx/systemctl restart nginx/g' /usr/serverok/ssl-renew
cat /usr/serverok/ssl-renew


mysql
create database USERNAME_wp;
grant all on USERNAME_wp.* to 'USERNAME_wp'@'localhost' identified by 'PASSWORD_HERE';


GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' IDENTIFIED BY 'PASSWORD_HERE' WITH GRANT OPTION;
GRANT PROXY ON ''@'' TO 'admin'@'localhost' WITH GRANT OPTION;


SFTP DOMAIN

IP = IP_ADDRESS_HERE
Port = 22
User = USERNAME
PW = GJd0f56QRrc48z

MySQL

DB = USERNAME_wp
User = USERNAME_wp
PW = PASSWORD_HERE

phpMyAdmin

http://IP_ADDRESS_HERE:8080

User = admin
PW = PASSWORD_HERE