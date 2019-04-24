DOMAIN
USERNAME
PASSWORD_HERE

-------------------------------------------------------------------

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

useradd -m -d /home/DOMAIN/ -s /bin/bash USERNAME

passwd USERNAME

PASSWORD_HERE

curl -s https://raw.githubusercontent.com/serverok/server-setup/master/data/debian/php-fpm-pool.txt -o /etc/php/7.2/fpm/pool.d/USERNAME.conf
sed -i 's/POOL_NAME/USERNAME/g' /etc/php/7.2/fpm/pool.d/USERNAME.conf
sed -i 's/FPM_USER/USERNAME/g' /etc/php/7.2/fpm/pool.d/USERNAME.conf


vi /etc/nginx/sites-available/DOMAIN.conf

server {
    listen 80;
    server_name DOMAIN www.DOMAIN;
    root /home/DOMAIN/html/;
    index index.php index.html index.htm;
    access_log /var/log/nginx/DOMAIN.log;
    error_log /var/log/nginx/DOMAIN-error.log;
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
    
    # Rewrites for Yoast SEO XML Sitemap
    # rewrite ^/sitemap_index.xml$ /index.php?sitemap=1 last;
    # rewrite ^/([^/]+?)-sitemap([0-9]+)?.xml$ /index.php?sitemap=$1&sitemap_n=$2 last;

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


mysql
create database USERNAME_wp;
grant all on USERNAME_wp.* to 'USERNAME_wp'@'localhost' identified by 'PASSWORD_HERE';


GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' IDENTIFIED BY 'PASSWORD_HERE' WITH GRANT OPTION;
GRANT PROXY ON ''@'' TO 'admin'@'localhost' WITH GRANT OPTION;
