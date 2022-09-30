#!/bin/bash
# Author: ServerOK.in
# Email: admin@serverok.in
# Web; https://serverok.in

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    OS=SuSe
elif [ -f /etc/redhat-release ]; then
    OS=RHEL
else
    echo "Unknown OS"
    exit 1
fi

if [ "$OS" == "Debian GNU/Linux" ]; then

    rm -f /usr/bin/certbot

    echo "Installing LetsEncrypt for Debian"

    apt update
    apt install -y certbot

    if [ -f /usr/sbin/apache2 ]; then
        echo "Installing Apache module for certbot"
        apt-get install -y python3-certbot-apache
    fi
    
    if [ -f /usr/sbin/nginx ]; then
        echo "Installing Nginx module for certbot"
        apt-get install -y python3-certbot-nginx 
    fi

elif [ "$OS" == "Ubuntu" ]; then

    echo "Installing LetsEncrypt for Ubuntu"

    apt update
    apt install -y certbot

    if [ -f /usr/sbin/apache2 ]; then
        echo "Installing Apache module for certbot"
        apt-get install -y python3-certbot-apache
    fi
    
    if [ -f /usr/sbin/nginx ]; then
        echo "Installing Nginx module for certbot"
        apt-get install -y python3-certbot-nginx 
    fi

elif [ "$OS" == "AlmaLinux" ]; then
    echo "Installing LetsEncrypt for AlmaLinux"
    dnf install -y certbot
    if [ -f /usr/sbin/httpd ]; then
        echo "Installing Apache module for certbot"
        dnf install -y python3-certbot-apache
    fi
    if [ -f /usr/sbin/nginx ]; then
        echo "Installing Nginx module for certbot"
        dnf install -y python3-certbot-nginx
    fi
else
    cd /usr/bin
    wget https://dl.eff.org/certbot-auto
    chmod a+x /usr/bin/certbot-auto
    rm -f /usr/bin/certbot
    mv /usr/bin/certbot-auto /usr/bin/certbot
    /usr/bin/certbot --install-only
fi

crontab -l > /root/crontab-backup
echo "@weekly /usr/serverok/ssl-renew >> /var/log/le-renew.log" >> /root/crontab-backup
crontab /root/crontab-backup
mv /root/crontab-backup /tmp/crontab-backup-$(date "+%Y-%m-%d-%H-%M-%S")

mkdir /usr/serverok/
wget https://raw.githubusercontent.com/serverok/server-setup/master/data/letsencrypt-renew.sh -O /usr/serverok/ssl-renew
chmod 755 /usr/serverok/ssl-renew

if [ -f /usr/sbin/apache2 ]; then
    sed -i 's/#systemctl restart apache2/systemctl restart apache2/g' /usr/serverok/ssl-renew
fi

if [ -f /usr/sbin/nginx ]; then
    sed -i 's/#systemctl restart nginx/systemctl restart nginx/g' /usr/serverok/ssl-renew
fi
