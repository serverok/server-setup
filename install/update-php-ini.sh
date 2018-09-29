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

if [ -f /etc/php/7.2/apache2/php.ini ]; then
    echo "Found PHP 7.2 Apache"
    cd /etc/php/7.2/apache2
    update_php_ini
    systemctl restart apache2
fi

if [ -f /etc/php/7.0/apache2/php.ini ]; then
    echo "Found PHP 7.0 Apache"
    cd /etc/php/7.0/apache2
    update_php_ini
    systemctl restart apache2
fi

if [ -f /etc/php/7.0/fpm/php.ini ]; then
    echo "Found PHP 7.0 php-fpm"
    cd /etc/php/7.0/fpm
    update_php_ini
    systemctl restart php7.0-fpm
fi

if [ -f /etc/php/7.2/fpm/php.ini ]; then
    echo "Found PHP 7.2 php-fpm"
    cd /etc/php/7.2/fpm
    update_php_ini
    systemctl restart php7.2-fpm
fi

if [ -f /etc/php.ini ]; then
    echo "Updating /etc/php.ini"
    cd /etc/
    update_php_ini
    service httpd restart
fi

if [ -f /opt/cpanel/ea-php56/root/etc/php.ini ]; then
    echo "Updating /opt/cpanel/ea-php56/root/etc/php.ini"
    cd /opt/cpanel/ea-php56/root/etc/
    update_php_ini
    service httpd restart
fi

if [ -f /opt/cpanel/ea-php70/root/etc/php.ini ]; then
    echo "Updating /opt/cpanel/ea-php70/root/etc/php.ini"
    cd /opt/cpanel/ea-php70/root/etc/
    update_php_ini
    service httpd restart
fi

if [ -f /opt/cpanel/ea-php71/root/etc/php.ini ]; then
    echo "Updating /opt/cpanel/ea-php71/root/etc/php.ini"
    cd /opt/cpanel/ea-php71/root/etc/
    update_php_ini
    service httpd restart
fi

if [ -f /opt/cpanel/ea-php72/root/etc/php.ini ]; then
    echo "Updating /opt/cpanel/ea-php72/root/etc/php.ini"
    cd /opt/cpanel/ea-php72/root/etc/
    update_php_ini
    service httpd restart
fi

if [ -f /usr/sbin/cagefsctl ]; then
    /usr/sbin/cagefsctl --force-update
fi