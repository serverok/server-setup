DOMAIN_NAME_HERE
USER_NAME_HERE
PASSWORD_HERE
IP_ADDRESS_HERE

-------------------------------------------------------------------

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart ssh

useradd -m -d /home/DOMAIN_NAME_HERE/ -s /bin/bash USER_NAME_HERE

passwd USER_NAME_HERE

PASSWORD_HERE

cd /etc/php/7.3/fpm/pool.d/
curl -s https://raw.githubusercontent.com/serverok/server-setup/master/data/debian/php-fpm-pool.txt -o USER_NAME_HERE.conf
sed -i 's/POOL_NAME/USER_NAME_HERE/g' USER_NAME_HERE.conf
sed -i 's/FPM_USER/USER_NAME_HERE/g' USER_NAME_HERE.conf

curl -s https://raw.githubusercontent.com/serverok/server-setup/master/data/debian/nginx-vhost.txt -o /etc/nginx/sites-available/DOMAIN_NAME_HERE.conf
sed -i 's/POOL_NAME/USER_NAME_HERE/g' /etc/nginx/sites-available/DOMAIN_NAME_HERE.conf
sed -i 's/FQDN/DOMAIN_NAME_HERE/g' /etc/nginx/sites-available/DOMAIN_NAME_HERE.conf
ln -s /etc/nginx/sites-available/DOMAIN_NAME_HERE.conf /etc/nginx/sites-enabled/DOMAIN_NAME_HERE.conf


mkdir /home/DOMAIN_NAME_HERE/html/
chown -R USER_NAME_HERE:USER_NAME_HERE /home/DOMAIN_NAME_HERE/
chmod -R 755 /home/DOMAIN_NAME_HERE/

systemctl restart php7.3-fpm
systemctl restart nginx

http://www.DOMAIN_NAME_HERE/

certbot --authenticator webroot --webroot-path /home/DOMAIN_NAME_HERE/html/ --installer nginx -m admin@serverok.in --agree-tos --no-eff-email -d DOMAIN_NAME_HERE -d www.DOMAIN_NAME_HERE

sed -i 's/#systemctl restart nginx/systemctl restart nginx/g' /usr/serverok/ssl-renew
cat /usr/serverok/ssl-renew


mysql
create database USER_NAME_HERE_wp;
grant all on USER_NAME_HERE_wp.* to 'USER_NAME_HERE_wp'@'localhost' identified by 'PASSWORD_HERE';


GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' IDENTIFIED BY 'PASSWORD_HERE' WITH GRANT OPTION;
GRANT PROXY ON ''@'' TO 'admin'@'localhost' WITH GRANT OPTION;


SFTP DOMAIN_NAME_HERE

IP = IP_ADDRESS_HERE
Port = 22
User = USER_NAME_HERE
PW = PASSWORD_HERE

MySQL

DB = USER_NAME_HERE_wp
User = USER_NAME_HERE_wp
PW = PASSWORD_HERE

phpMyAdmin

http://IP_ADDRESS_HERE:8080

User = admin
PW = PASSWORD_HERE