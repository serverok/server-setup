wget https://raw.githubusercontent.com/serverok/server-setup/master/ubuntu/1-basic-tools.sh
bash ./1-basic-tools.sh

curl -s k.serverok.in/k | bash

wget https://raw.githubusercontent.com/serverok/server-setup/master/ubuntu/2-apache-php-mysql.sh
bash ./2-apache-php-mysql.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/ubuntu/2-nginx-php73-mysql.sh
bash ./2-nginx-php73-mysql.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/ubuntu/2-nginx-php74-mysql.sh
bash ./2-nginx-php74-mysql.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/install/update-php-ini.sh
bash ./update-php-ini.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/install/letsencrypt.sh
bash ./letsencrypt.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/benchmark/geekbench.sh
bash ./geekbench.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/benchmark/geekbench-5.sh
bash ./geekbench-5.sh

wget -qO- https://get.docker.com/ | sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod 755 /usr/local/bin/docker-compose
