wget https://raw.githubusercontent.com/serverok/server-setup/master/debian/1-basic-tools.sh
bash 1-basic-tools.sh

curl -s k.serverok.in/k | bash

wget https://raw.githubusercontent.com/serverok/server-setup/master/debian/2-apache-php-mysql.sh
bash 2-apache-php-mysql.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/debian/2-apache-php56-mysql.sh
bash 2-apache-php56-mysql.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/debian/2-nginx-php-73-mysql.sh
bash 2-nginx-php-73-mysql.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/debian/2-nginx-php-74-mysql.sh
bash 2-nginx-php-74-mysql.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/debian/2-nginx-php-72-mysql.sh
bash 2-nginx-php-72-mysql.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/install/update-php-ini.sh
bash ./update-php-ini.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/install/letsencrypt.sh
bash ./letsencrypt.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/debian/upgrade-debian-8.sh
bash upgrade-debian-8.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/debian/upgrade-debian-9.sh
bash upgrade-debian-9.sh

apt install automysqlbackup -y

wget https://raw.githubusercontent.com/serverok/server-setup/master/tools/sok-nginx-add-site.py -O /usr/local/bin/sok-site-add
chmod 755 /usr/local/bin/sok-site-add

wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
chmod 755 /usr/local/bin/wp


GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' IDENTIFIED BY 'MYSQL_PASSWORD' WITH GRANT OPTION;
GRANT PROXY ON ''@'' TO 'admin'@'localhost' WITH GRANT OPTION;


