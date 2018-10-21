# https://www.phpmyadmin.net/

cd /usr/local/src
wget https://files.phpmyadmin.net/phpMyAdmin/4.8.3/phpMyAdmin-4.8.3-all-languages.zip
unzip phpMyAdmin-4.8.3-all-languages.zip
mkdir /usr/serverok
rm -rf /usr/serverok/phpmyadmin
mv phpMyAdmin-4.8.3-all-languages /usr/serverok/phpmyadmin
mkdir /usr/serverok/phpmyadmin/tmp/
chmod 777 /usr/serverok/phpmyadmin/tmp/
cp /usr/serverok/phpmyadmin/config.sample.inc.php /usr/serverok/phpmyadmin/config.inc.php

sed -i  's/$cfg\[.blowfish_secret.\] = .*$/$cfg\["blowfish_secret"\] = "ohhae8Fa6oJohrohng0ieV0to3aiThae";/g' /usr/serverok/phpmyadmin/config.inc.php

vi /etc/httpd/conf.d/phpmyadmin.conf
vi /etc/apache2/conf-enabled/phpmyadmin.conf


Alias /phpmyadmin "/usr/serverok/phpmyadmin"
  
<Directory "/usr/serverok/phpmyadmin">
    AllowOverride All
    Options FollowSymlinks
    Order allow,deny
    Allow from all
   <IfModule mod_authz_core.c>
     <RequireAny>
       Require all granted
     </RequireAny>
   </IfModule>
</Directory>


systemctl restart apache2
service httpd restart



location /phpmyadmin {
    root /usr/serverok/;
    index index.php;
    location ~ ^/phpmyadmin/(.*\.php)$ {
            include snippets/fastcgi-php.conf;
            proxy_read_timeout 180;
            fastcgi_intercept_errors on;
            fastcgi_buffers 16 16k;
            fastcgi_buffer_size 32k;
            fastcgi_pass unix:/run/php/php7.2-fpm.sock;
    }
}

location /phpmyadmin {
    root /usr/serverok/;
    index index.php index.html index.htm;
    location ~ ^/phpmyadmin/(.+\.php)$ {
            try_files $uri =404;
            root /usr/serverok/;
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $request_filename;
            include /etc/nginx/fastcgi_params;
            fastcgi_param PATH_INFO $fastcgi_script_name;
            fastcgi_buffer_size 128k;
            fastcgi_buffers 256 4k;
            fastcgi_busy_buffers_size 256k;
            fastcgi_temp_file_write_size 256k;
            # if on, no errors will be shown.
            fastcgi_intercept_errors off;
    }
    location ~* ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
            root /usr/serverok/;
    }
}


server {
    listen *:90;
    server_name _;
    root /usr/serverok/phpmyadmin/;
    index index.php;
    client_max_body_size 100M;
    location = /favicon.ico {
            log_not_found off;
            access_log off;
    }
    location = /robots.txt {
            allow all;
            log_not_found off;
            access_log off;
    }
    location / {
            try_files $uri $uri/ /index.php?$args;
    }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        proxy_read_timeout 180;
        fastcgi_intercept_errors on;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_pass unix:/run/php/php7.2-fpm.sock;
    }
}

vi /etc/apache2/conf-enabled/phpmyadmin.conf

Listen 90

<VirtualHost *:90>
    DocumentRoot /usr/serverok/phpmyadmin/
    CustomLog ${APACHE_LOG_DIR}/pma.log combined
    <Directory "/usr/serverok/phpmyadmin">
        Options All
        AllowOverride All
        Require all granted
        Order allow,deny
        allow from all
    </Directory>
</VirtualHost>
