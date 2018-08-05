wget https://raw.githubusercontent.com/serverok/server-setup/master/debian/1-basic-tools.sh
bash 1-basic-tools.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/debian/2-apache-php-mysql.sh
bash 2-apache-php-mysql.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/install/letsencrypt.sh
sh ./letsencrypt.sh

curl -s k.serverok.in/k | bash

apt install automysqlbackup -y

wget https://raw.githubusercontent.com/serverok/server-setup/master/install/update-php-ini.sh
sh ./update-php-ini.sh