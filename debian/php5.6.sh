apt install apt-transport-https lsb-release ca-certificates -y
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list


apt-get update

apt install -y  php5.6-bcmath php5.6-cli php5.6-common php5.6-curl php5.6-gd php5.6-imap php5.6-intl php5.6-json php5.6-mbstring php5.6-mcrypt php5.6-mysql php5.6-readline php5.6-soap php5.6-xml php5.6-xmlrpc php5.6-zip

php5.6

phpenmod -v 5.6 simplexml


apt install -y php5.6-fpm

a2dismod php7.0

apt install libapache2-mod-php5.6
a2enmod rewrite
