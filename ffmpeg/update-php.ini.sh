#!/bin/bash

if [ -f /usr/local/lib/php.ini ];
then
    cd /usr/local/lib/
elif [ -f /etc/php.ini ];
then
    cd /etc
elif [ -f /etc/php5/apache2/php.ini ];
then
    cd /etc/php5/apache2/
else
    echo "php.ini not found"
    exit 1;
fi

sed -i "s/max_execution_time\s*=.*/max_execution_time = 600/g" php.ini
sed -i "s/max_input_time\s*=.*/max_input_time = 6000/g" php.ini
sed -i "s/memory_limit\s*=.*/memory_limit = 128M/g" php.ini
sed -i "s/display_errors\s*=.*/display_errors = On/g" php.ini
sed -i "s/file_uploads\s*=.*/file_uploads = On/g" php.ini
sed -i "s/post_max_size\s*=.*/post_max_size = 800M/g" php.ini
sed -i "s/upload_max_filesize\s*=.*/upload_max_filesize = 800M/g" php.ini
sed -i "s/session.gc_maxlifetime\s*=.*/session.gc_maxlifetime = 14400/g" php.ini
sed -i "s/error_reporting\s*=.*/error_reporting = E_COMPILE_ERROR|E_ERROR|E_CORE_ERROR/g" php.ini
sed -i "s/max_file_uploads = On/max_file_uploads = 1000/g" php.ini

if [ -f /etc/debian_version ]; then
    service apache2 restart
elif [ -f /etc/redhat-release ]; then
    service httpd restart
else
    echo "Unknown OS, restart apache yourself"
fi

