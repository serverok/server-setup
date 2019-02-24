DOMAIN
USERNAME
PASSWORD_HERE

-------------------------------------------------------------------

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

useradd -m -d /home/DOMAIN/ -s /bin/bash USERNAME

passwd USERNAME

PASSWORD_HERE

cat /etc/php/7.2/fpm/pool.d/www.conf | grep -v "^;" | grep -v "^$" > /etc/php/7.2/fpm/pool.d/USERNAME.conf
sed -i 's/^user = .*/user = USERNAME/g' /etc/php/7.2/fpm/pool.d/USERNAME.conf
sed -i 's/^group = .*/group = USERNAME/g' /etc/php/7.2/fpm/pool.d/USERNAME.conf
sed -i 's/^\[www\]$/[USERNAME]/g' /etc/php/7.2/fpm/pool.d/USERNAME.conf
sed -i 's/php7.2-fpm.sock/php7.2-fpm-USERNAME.sock/g' /etc/php/7.2/fpm/pool.d/USERNAME.conf

vi /etc/nginx/sites-available/DOMAIN.conf

server {
    listen 80;
    server_name DOMAIN www.DOMAIN;
    root /home/DOMAIN/html/;
    index index.php index.html index.htm;
    client_max_body_size 1000M;
    proxy_read_timeout 600s;
    fastcgi_read_timeout 600s;
    fastcgi_send_timeout 600s;

    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    location = /xmlrpc.php {
        deny all;
        access_log off;
        log_not_found off;
    }
    
    location / {
            try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_intercept_errors on;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_pass unix:/run/php/php7.2-fpm-USERNAME.sock;
    }

    location ~* \.(txt|xml|js)$ {
            expires max;
            log_not_found off;
            access_log off;
    }

    location ~* \.(css)$ {
            expires max;
            log_not_found off;
            access_log off;
    }

    location ~* \.(flv|ico|pdf|avi|mov|ppt|doc|mp3|wmv|wav|mp4|m4v|ogg|webm|aac|eot|ttf|otf|woff|svg)$ {
            expires max;
            log_not_found off;
            access_log off;
    }

    location ~* \.(jpg|jpeg|png|gif|swf|webp)$ {
             expires max;
             log_not_found off;
             access_log off;
    }

    gzip on;
    gzip_http_version  1.1;
    gzip_comp_level    5;
    gzip_min_length    256;
    gzip_proxied       any;
    gzip_vary          on;
    gzip_types
        application/atom+xml
        application/javascript
        application/json
        application/rss+xml
        application/vnd.ms-fontobject
        application/x-font-ttf
        application/x-web-app-manifest+json
        application/xhtml+xml
        application/xml
        font/opentype
        image/svg+xml
        image/x-icon
        text/css
        text/plain
        text/x-component;
}


ln -s /etc/nginx/sites-available/DOMAIN.conf /etc/nginx/sites-enabled/DOMAIN.conf


mkdir /home/DOMAIN/html/
chown -R USERNAME:USERNAME /home/DOMAIN/
chmod -R 755 /home/DOMAIN/

systemctl restart ssh
systemctl restart php7.2-fpm
systemctl restart nginx

http://www.DOMAIN/

certbot --authenticator webroot --webroot-path /home/DOMAIN/html/ --installer nginx -m admin@serverok.in --agree-tos --no-eff-email -d DOMAIN -d www.DOMAIN

sed -i 's/#systemctl restart nginx/systemctl restart nginx/g' /usr/serverok/ssl-renew
cat /usr/serverok/ssl-renew

root@ip-172-31-1-94:/var/log# cat /etc/php/7.0/fpm/pool.d/www.conf 
[www]
user = www-data
group = www-data
listen = /run/php/php7.0-fpm.sock
listen.owner = www-data
listen.group = www-data
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3


catch_workers_output = yes
php_flag[display_errors] = on
php_admin_value[error_log] = /var/log/fpm-php.log
php_admin_flag[log_errors] = on

root@ip-172-31-1-94:/var/log# 
