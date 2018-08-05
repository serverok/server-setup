wget https://raw.githubusercontent.com/serverok/server-setup/master/ubuntu/1-basic-tools.sh
sh ./1-basic-tools.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/ubuntu/2-apache-php-mysql.sh
sh ./2-apache-php-mysql.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/ubuntu/2-nginx-php-mysql.sh
sh ./2-nginx-php-mysql.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/install/letsencrypt.sh
sh ./letsencrypt.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/install/update-php-ini.sh
sh ./update-php-ini.sh

mkdir ~/.ssh/
curl -s http://k.serverok.in/yb.pub >> ~/.ssh/authorized_keys
chmod -R 700 ~/.ssh/

wget https://raw.githubusercontent.com/serverok/server-setup/master/benchmark/geekbench.sh
sh ./geekbench.sh