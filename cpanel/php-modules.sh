#!/bin/bash
# Author: ServerOK.in
# Email: admin@serverOK.in
# Install PHP modules in Cpanel Server.

PHP_VERSIONS=(
    "56"
    "70"
    "71"
    "72"
    "73"
)

PHP_MODULES=(
    'curl'
    'exif'
    'ioncube10'
    'iconv'
    "intl"
    'fileinfo'
    'fpm'
    'mbstring'
    'soap'
    'zip'
    "gd"
)

for ((i=0; i < ${#PHP_MODULES[*]}; i++)); do
    for ((j=0; j < ${#PHP_VERSIONS[*]}; j++)); do
        echo "Installing ea-php${PHP_VERSIONS[$j]}-php-${PHP_MODULES[$i]}"
        yum -y install ea-php${PHP_VERSIONS[$j]}-php-${PHP_MODULES[$i]}
    done
done
