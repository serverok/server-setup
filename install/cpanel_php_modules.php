<?php
# Author: ServerOK.in
# Email: admin@serverOK.in
# Install PHP modules in Cpanel Server.

$phpVersions = [
    '56',
    '70',
    '71',
    '72'
];

$phpExtensions = [
    'curl',
    'exif',
    'ioncube10',
    'iconv',
    'intl',
    'fileinfo',
    'fpm',
    'mbstring',
    'soap',
    'zip',
];

foreach ($phpExtensions as $phpExtension) {
    $cmd = 'yum install -y ';
    foreach ($phpVersions as $phpVersion) {
        $cmd .= ' ea-php' . $phpVersion . '-php-' . $phpExtension;
    }
    echo $cmd . "\n";
    exec("$cmd");
}
