add-apt-repository ppa:ondrej/php
apt update
apt -y upgrade
apt install -y php5.6 php5.6-mysql php5.6-gd php5.6-mbstring php5.6-mcrypt php5.6-zip php5.6-curl php5.6-xml

apt install -y php5.6-fpm

apt install libapache2-mod-php5.6
a2enmod rewrite

/etc/php/5.6/apache2/php.ini
service apache2 restart
