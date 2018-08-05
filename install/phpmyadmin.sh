cd /usr/local/src
wget https://files.phpmyadmin.net/phpMyAdmin/4.8.2/phpMyAdmin-4.8.2-all-languages.zip
unzip phpMyAdmin-4.8.2-all-languages.zip
mkdir /usr/serverok
rm -rf /usr/serverok/phpmyadmin
mv phpMyAdmin-4.8.2-all-languages /usr/serverok/phpmyadmin
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


systemctl apache2 restart
service httpd restart

