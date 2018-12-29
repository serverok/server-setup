apt install apt-transport-https lsb-release ca-certificates -y
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list


apt-get update

apt install -y  php7.1-bcmath php7.1-cli php7.1-common php7.1-curl php7.1-gd php7.1-imap php7.1-intl php7.1-json php7.1-mbstring php7.1-mysql php7.1-readline php7.1-soap php7.1-xml php7.1-xmlrpc php7.1-zip


phpenmod -v 7.1 simplexml


apt install -y php7.1-fpm

a2dismod php7.0

apt install libapache2-mod-php7.1
a2enmod rewrite


cd /etc/php/7.1/fpm/
cd /etc/php/7.1/apache2/
/bin/sed -i "s/max_execution_time\s*=.*/max_execution_time = 600/g" php.ini
/bin/sed -i "s/max_input_time\s*=.*/max_input_time = 6000/g" php.ini
/bin/sed -i "s/memory_limit\s*=.*/memory_limit = 512M/g" php.ini
/bin/sed -i "s/display_errors\s*=.*/display_errors = On/g" php.ini
/bin/sed -i "s/file_uploads\s*=.*/file_uploads = On/g" php.ini
/bin/sed -i "s/post_max_size\s*=.*/post_max_size = 800M/g" php.ini
/bin/sed -i "s/upload_max_filesize\s*=.*/upload_max_filesize = 800M/g" php.ini
/bin/sed -i "s/session.gc_maxlifetime\s*=.*/session.gc_maxlifetime = 14400/g" php.ini
/bin/sed -i "s/error_reporting\s*=.*/error_reporting = E_COMPILE_ERROR|E_ERROR|E_CORE_ERROR/g" php.ini
/bin/sed -i "s/max_file_uploads = On/max_file_uploads = 1000/g" php.ini

systemctl enable php7.1-fpm
systemctl enable nginx
service apache2 restart
