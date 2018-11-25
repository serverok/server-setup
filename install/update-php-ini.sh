#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in

function update_php_ini() {
    sed -i "s/max_execution_time\s*=.*/max_execution_time = 600/g" php.ini
    sed -i "s/max_input_time\s*=.*/max_input_time = 6000/g" php.ini
    sed -i "s/memory_limit\s*=.*/memory_limit = 256M/g" php.ini
    sed -i "s/display_errors\s*=.*/display_errors = On/g" php.ini
    sed -i "s/file_uploads\s*=.*/file_uploads = On/g" php.ini
    sed -i "s/post_max_size\s*=.*/post_max_size = 800M/g" php.ini
    sed -i "s/upload_max_filesize\s*=.*/upload_max_filesize = 800M/g" php.ini
    sed -i "s/session.gc_maxlifetime\s*=.*/session.gc_maxlifetime = 14400/g" php.ini
    sed -i "s/error_reporting\s*=.*/error_reporting = E_COMPILE_ERROR|E_ERROR|E_CORE_ERROR/g" php.ini
    sed -i "s/max_file_uploads = On/max_file_uploads = 1000/g" php.ini
    sed -i 's/; max_input_vars = 1000/max_input_vars = 3000/g' php.ini
    sed -i "s/^enable_dl = On/enable_dl = Off/g" php.ini
}

if [ -f /etc/php/5.6/fpm/php.ini ]; then
    echo "Found PHP 5.6 php-fpm"
    cd /etc/php/5.6/fpm
    update_php_ini
    systemctl restart php5.6-fpm
fi

if [ -f /etc/php/7.0/fpm/php.ini ]; then
    echo "Found PHP 7.0 php-fpm"
    cd /etc/php/7.0/fpm
    update_php_ini
    systemctl restart php7.0-fpm
fi

if [ -f /etc/php/7.1/fpm/php.ini ]; then
    echo "Found PHP 7.1 php-fpm"
    cd /etc/php/7.1/fpm
    update_php_ini
    systemctl restart php7.1-fpm
fi

if [ -f /etc/php/7.2/fpm/php.ini ]; then
    echo "Found PHP 7.2 php-fpm"
    cd /etc/php/7.2/fpm
    update_php_ini
    systemctl restart php7.2-fpm
fi

PHP_INI_APACHE_PATHS=(
/etc/php/5.6/apache2/php.ini
/etc/php/7.0/apache2/php.ini
/etc/php/7.1/apache2/php.ini
/etc/php/7.2/apache2/php.ini
)

for php_ini_path in ${PHP_INI_APACHE_PATHS[@]}; do
    if [ -f $php_ini_path ]; then
        echo "Updating $php_ini_path"
        cd $(dirname "${php_ini_path}")
        update_php_ini
        systemctl restart apache2
    fi
done

PHP_INI_PATHS=(
/etc/php.ini
/opt/cpanel/ea-php56/root/etc/php.ini
/opt/cpanel/ea-php70/root/etc/php.ini
/opt/cpanel/ea-php71/root/etc/php.ini
/opt/cpanel/ea-php72/root/etc/php.ini
/opt/alt/php44/etc/php.ini
/opt/alt/php51/etc/php.ini
/opt/alt/php52/etc/php.ini
/opt/alt/php53/etc/php.ini
/opt/alt/php54/etc/php.ini
/opt/alt/php55/etc/php.ini
/opt/alt/php56/etc/php.ini
/opt/alt/php70/etc/php.ini
/opt/alt/php71/etc/php.ini
/opt/alt/php72/etc/php.ini
)

for php_ini_path in ${PHP_INI_PATHS[@]}; do
    if [ -f $php_ini_path ]; then
        echo "Updating $php_ini_path"
        cd $(dirname "${php_ini_path}")
        update_php_ini
    fi
done

if [ -f /etc/init.d/httpd ]; then
   service httpd restart
fi

if [ -f /usr/sbin/cagefsctl ]; then
    /usr/sbin/cagefsctl --force-update
fi
