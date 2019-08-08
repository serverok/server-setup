apt install apt-transport-https lsb-release ca-certificates -y
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list


apt-get update

apt install -y  php7.2-bcmath php7.2-cli php7.2-common php7.2-curl php7.2-gd php7.2-imap php7.2-intl php7.2-json php7.2-mbstring php7.2-mysql php7.2-readline php7.2-soap php7.2-xml php7.2-xmlrpc php7.2-zip


phpenmod -v 7.2 simplexml


apt install -y php7.2-fpm

a2dismod php7.0

apt install libapache2-mod-php7.2
a2enmod rewrite


cd /etc/php/7.2/fpm/
cd /etc/php/7.2/apache2/


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

systemctl enable php7.2-fpm
systemctl enable nginx
systemctl restart apache2

