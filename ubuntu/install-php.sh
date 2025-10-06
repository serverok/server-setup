#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

PHP_VERSIONS=("7.2" "7.3" "7.4" "8.0" "8.1" "8.2" "8.3" "8.4")

echo "Select PHP version to install:"
for i in "${!PHP_VERSIONS[@]}"; do
    echo "$((i+1))) ${PHP_VERSIONS[$i]}"
done

read -p "Enter the number corresponding to the PHP version (1-${#PHP_VERSIONS[@]}): " choice

if ! [[ "$choice" =~ ^[1-9][0-9]*$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#PHP_VERSIONS[@]}" ]; then
  echo "Invalid input. Please enter a number between 1 and ${#PHP_VERSIONS[@]}."
  exit 1
fi

PHP_VERSION="${PHP_VERSIONS[$((choice-1))]}"

echo "You selected PHP $PHP_VERSION"


add-apt-repository -y ppa:ondrej/php
apt -y upgrade

apt install -y  php${PHP_VERSION}-bcmath php${PHP_VERSION}-cli php${PHP_VERSION}-common php${PHP_VERSION}-curl php${PHP_VERSION}-gd php${PHP_VERSION}-imap php${PHP_VERSION}-intl php${PHP_VERSION}-mbstring php${PHP_VERSION}-mysql php${PHP_VERSION}-readline php${PHP_VERSION}-soap php${PHP_VERSION}-xml php${PHP_VERSION}-xmlrpc php${PHP_VERSION}-zip php${PHP_VERSION}-gmp

apt -y install php${PHP_VERSION}-fpm

if [ -f update-php-ini.sh ]; then
  rm -f ./update-php-ini.sh
fi

wget https://raw.githubusercontent.com/serverok/server-setup/master/install/update-php-ini.sh
bash ./update-php-ini.sh

if [ -f update-php-ini.sh ]; then
  rm -f ./update-php-ini.sh
fi

systemctl enable php${PHP_VERSION}-fpm
systemctl restart php${PHP_VERSION}-fpm
