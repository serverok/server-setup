#!/bin/bash
# Author: admin@serverOk.in
# Web: https://serverok.in

function update_php_ini() {
    sed -i "s/max_execution_time\s*=.*/max_execution_time = 600/g" php.ini
    sed -i "s/max_input_time\s*=.*/max_input_time = 6000/g" php.ini
    sed -i "s/memory_limit\s*=.*/memory_limit = 512M/g" php.ini
    sed -i "s/display_errors\s*=.*/display_errors = On/g" php.ini
    sed -i "s/file_uploads\s*=.*/file_uploads = On/g" php.ini
    sed -i "s/post_max_size\s*=.*/post_max_size = 4000M/g" php.ini
    sed -i "s/upload_max_filesize\s*=.*/upload_max_filesize = 4000M/g" php.ini
    sed -i "s/session.gc_maxlifetime\s*=.*/session.gc_maxlifetime = 14400/g" php.ini
    sed -i "s/error_reporting\s*=.*/error_reporting = E_COMPILE_ERROR|E_ERROR|E_CORE_ERROR/g" php.ini
    sed -i "s/max_file_uploads = On/max_file_uploads = 1000/g" php.ini
    sed -i 's/;\s*max_input_vars = 1000/max_input_vars = 3000/g' php.ini
    sed -i "s/^enable_dl = On/enable_dl = Off/g" php.ini
}

php_versions=(5.6 7.0 7.1 7.2 7.3 7.4 8.0 8.1 8.2 8.3 8.4)

for version in "${php_versions[@]}"; do
  if [ -f "/etc/php/${version}/fpm/php.ini" ]; then
    echo "Found PHP ${version} php-fpm"
    cd "/etc/php/${version}/fpm"
    update_php_ini
    systemctl restart "php${version}-fpm"
  fi
done

if [ -f /usr/local/lsws/lsphp73/etc/php/7.3/litespeed/php.ini ]; then
    echo "OpenLiteSpeed lsphp73"
    cd /usr/local/lsws/lsphp73/etc/php/7.3/litespeed/
    update_php_ini
    touch /usr/local/lsws/admin/tmp/.lsphp_restart.txt
fi

PHP_INI_APACHE_PATHS=(
/etc/php/5.6/apache2/php.ini
/etc/php/7.0/apache2/php.ini
/etc/php/7.1/apache2/php.ini
/etc/php/7.2/apache2/php.ini
/etc/php/7.3/apache2/php.ini
/etc/php/7.4/apache2/php.ini
/etc/php/8.0/apache2/php.ini
/etc/php/8.1/apache2/php.ini
/etc/php/8.2/apache2/php.ini
/etc/php/8.3/apache2/php.ini
/etc/php/8.4/apache2/php.ini
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
/opt/cpanel/ea-php53/root/etc/php.ini
/opt/cpanel/ea-php52/root/etc/php.ini
/opt/cpanel/ea-php56/root/etc/php.ini
/opt/cpanel/ea-php70/root/etc/php.ini
/opt/cpanel/ea-php71/root/etc/php.ini
/opt/cpanel/ea-php72/root/etc/php.ini
/opt/cpanel/ea-php73/root/etc/php.ini
/opt/cpanel/ea-php74/root/etc/php.ini
/opt/cpanel/ea-php80/root/etc/php.ini
/opt/cpanel/ea-php81/root/etc/php.ini
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
/opt/alt/php73/etc/php.ini
/opt/alt/php74/etc/php.ini
/opt/alt/php80/etc/php.ini
/opt/alt/php81/etc/php.ini
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
