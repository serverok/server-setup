DOMAIN
USERNAME

-------------------------------------------------------------------

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

useradd -m -d /home/DOMAIN/ -s /bin/bash USERNAME

passwd USERNAME

yu@wEFBrPjqjj1

#sed -i 's/www-data/USERNAME/g' /etc/nginx/nginx.conf
cp /etc/php/7.2/fpm/pool.d/www.conf /etc/php/7.2/fpm/pool.d/UNSERNAME.conf
sed -i 's/www-data/USERNAME/g' /etc/php/7.2/fpm/pool.d/USERNAME.conf

vi /etc/nginx/sites-available/DOMAIN.conf

mkdir /home/DOMAIN/html/
chown -R USERNAME:USERNAME /home/DOMAIN/


server {
    listen 80;
    server_name DOMAIN www.DOMAIN;
    root /home/DOMAIN/html/;
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
rm -f /etc/nginx/sites-enabled/default


systemctl restart ssh
systemctl restart php7.2-fpm
systemctl restart nginx


http://www.DOMAIN/

certbot --authenticator webroot --webroot-path /home/DOMAIN/html/ --installer nginx -d DOMAIN -d www.DOMAIN

