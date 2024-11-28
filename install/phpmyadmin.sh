# https://www.phpmyadmin.net/

mkdir /usr/serverok/
rm -rf /usr/serverok/phpmyadmin

cd /usr/local/src
rm -f phpMyAdmin-latest-all-languages.tar.gz
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
tar xvf phpMyAdmin-latest-all-languages.tar.gz
mv phpMyAdmin-5.2.1-all-languages /usr/serverok/phpmyadmin

cd /usr/local/src
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.7/phpMyAdmin-4.9.7-all-languages.tar.gz
tar xvf phpMyAdmin-4.9.7-all-languages.tar.gz
mv phpMyAdmin-4.9.7-all-languages /usr/serverok/phpmyadmin

cd /usr/serverok/phpmyadmin/
mkdir tmp
chmod 777 tmp
cp config.sample.inc.php config.inc.php
sed -i  's/$cfg\[.blowfish_secret.\] = .*$/$cfg\["blowfish_secret"\] = "ohhae8Fa6oJohrohng0ieV0to3aiThae";/g' config.inc.php

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

chcon -R -t httpd_sys_rw_content_t /usr/serverok/phpmyadmin/tmp/


https://gist.github.com/serverok/9627c6fcb39d4ba11c4a109222ec36b1

curl -s https://raw.githubusercontent.com/serverok/server-setup/master/data/debian/nginx-phpmyadmin.conf -o /etc/nginx/pma.conf
cat /etc/nginx/pma.conf

vi /etc/nginx/sites-enabled/default

include /etc/nginx/pma.conf;

location /phpmyadmin {
    client_max_body_size 200M;
    proxy_read_timeout 600s;
    fastcgi_read_timeout 600s;
    fastcgi_send_timeout 600s;
    root /usr/serverok/;
    index index.php;
    location ~ ^/phpmyadmin/(.*\.php)$ {
            include snippets/fastcgi-php.conf;
            proxy_read_timeout 180;
            fastcgi_intercept_errors on;
            fastcgi_buffers 16 16k;
            fastcgi_buffer_size 32k;
            fastcgi_pass unix:/run/php/php7.3-fpm.sock;
    }
}

location /phpmyadmin {
    client_max_body_size 200M;
    proxy_read_timeout 600s;
    fastcgi_read_timeout 600s;
    fastcgi_send_timeout 600s;
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

vi /etc/nginx/sites-enabled/phpmyadmin.conf
vi /etc/nginx/conf.d/phpmyadmin.conf

server {
    listen *:7777;
    server_name _;
    root /usr/serverok/phpmyadmin/;
    index index.php;
    client_max_body_size 500M;
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
    location / {
            try_files $uri $uri/ /index.php?$args;
    }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_intercept_errors on;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_pass unix:/run/php/php8.2-fpm.sock;
    }
}

If CentOS

location ~ \.php$ {
    try_files $uri =404;
    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
}

vi /etc/apache2/conf-enabled/phpmyadmin.conf

Listen 7777

<VirtualHost *:7777>
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


Listen 7777

<VirtualHost *:7777>
    DocumentRoot /usr/serverok/phpmyadmin/
    CustomLog ${APACHE_LOG_DIR}/pma.log combined
    <FilesMatch \.php$>
        SetHandler "proxy:unix:/run/php/php8.2-fpm.sock|fcgi://localhost/"
    </FilesMatch>
    <Directory "/usr/serverok/phpmyadmin">
        Options All
        AllowOverride All
        Require all granted
        Order allow,deny
        allow from all
    </Directory>
</VirtualHost>


vi /etc/httpd/conf.d/phpmyadmin.conf

Listen 7777

<VirtualHost *:7777>
    DocumentRoot /usr/serverok/phpmyadmin/
    CustomLog /var/log/httpd/pma.log combined
    <Directory "/usr/serverok/phpmyadmin">
        Options All
        AllowOverride All
        Require all granted
        Order allow,deny
        allow from all
    </Directory>
</VirtualHost>




=============================================================================
Normal User
=============================================================================

MariaDB/MySQL 5.7

CREATE DATABASE DB_NAME;
GRANT ALL PRIVILEGES ON DB_NAME.* to 'USERNAME'@'localhost' IDENTIFIED BY 'MYSQL_PASSWORD';


MySQL 8

CREATE DATABASE DB_NAME;
CREATE USER 'USERNAME'@'localhost' IDENTIFIED BY 'MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON DB_NAME.* TO 'USERNAME'@'localhost';
FLUSH PRIVILEGES;


ALTER USER 'admin'@'%' IDENTIFIED BY 'NewPassword';



=============================================================================
ROOT USER
=============================================================================

GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' IDENTIFIED BY 'MYSQL_PASSWORD' WITH GRANT OPTION;
GRANT PROXY ON ''@'' TO 'admin'@'localhost' WITH GRANT OPTION;

CREATE USER 'admin'@'%' IDENTIFIED BY 'AEs308SuEtT0Hs';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;

MySQL 8

CREATE USER 'admin'@'localhost' IDENTIFIED BY '123';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;

revoke all SUPER privileges from users other than root.

UPDATE mysql.user SET super_priv='N' WHERE user<>'root';
FLUSH PRIVILEGES;

/etc/phpmyadmin/config.inc.php

$cfg["blowfish_secret"] = "ohhae8Fa6oJohrohng0ieV0to3aiThae";

https://stackoverflow.com/questions/48001569/phpmyadmin-count-parameter-must-be-an-array-or-an-object-that-implements-co/49483740#49483740


MySQL 8 root (show grants;)

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, SHUTDOWN, PROCESS, FILE, REFERENCES, INDEX, ALTER, SHOW DATABASES, SUPER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER, CREATE TABLESPACE, CREATE ROLE, DROP ROLE ON *.* TO `admin`@`localhost` WITH GRANT OPTION;
GRANT APPLICATION_PASSWORD_ADMIN,AUDIT_ADMIN,BACKUP_ADMIN,BINLOG_ADMIN,BINLOG_ENCRYPTION_ADMIN,CLONE_ADMIN,CONNECTION_ADMIN,ENCRYPTION_KEY_ADMIN,FLUSH_OPTIMIZER_COSTS,FLUSH_STATUS,FLUSH_TABLES,FLUSH_USER_RESOURCES,GROUP_REPLICATION_ADMIN,INNODB_REDO_LOG_ARCHIVE,INNODB_REDO_LOG_ENABLE,PERSIST_RO_VARIABLES_ADMIN,REPLICATION_APPLIER,REPLICATION_SLAVE_ADMIN,RESOURCE_GROUP_ADMIN,RESOURCE_GROUP_USER,ROLE_ADMIN,SERVICE_CONNECTION_ADMIN,SESSION_VARIABLES_ADMIN,SET_USER_ID,SHOW_ROUTINE,SYSTEM_USER,SYSTEM_VARIABLES_ADMIN,TABLE_ENCRYPTION_ADMIN,XA_RECOVER_ADMIN ON *.* TO `admin`@`localhost` WITH GRANT OPTION;
GRANT PROXY ON ''@'' TO 'admin'@'localhost' WITH GRANT OPTION;

DELETE A User

DROP USER 'admin2'@'localhost';

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Zu5riT1i-sAUwTwsN';
SELECT user,host,plugin FROM mysql.user;
UPDATE mysql.user SET Plugin='' WHERE user='root';
UPDATE mysql.user SET Plugin='auth_socket' WHERE user='root';
UPDATE mysql.user SET Plugin='caching_sha2_password' WHERE user='root';
UPDATE mysql.user SET Plugin='mysql_native_password' WHERE user='root';




ALTER USER 'colegiomedico_atom'@'localhost' IDENTIFIED BY 'new_password_here';

SET PASSWORD FOR 'colegiomedico_atom'@'localhost' = PASSWORD('new_password_here');
FLUSH PRIVILEGES;

If you're changing your own password (the user you're currently logged in as), you can simply use:

ALTER USER USER() IDENTIFIED BY 'new_password_here';
