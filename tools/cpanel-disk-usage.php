<?php
# Author: Yujin Boby
# Website: https://serverOk.in
# Email: admin@serverOk.in
# This script is used to generate disk usage for web sites on a cpanel server.
# cd /home; du -k --max-depth=1 | sort -n > /root/disk_usage.txt
# php /root/du.php > /usr/local/apache/htdocs/usage.txt
# chmod 777 /usr/local/apache/htdocs/usage.txt
# ifconfig | grep inet

$dulines = file('/root/disk_usage.txt');
$dulines = array_reverse($dulines);

foreach ($dulines as $du_line) {
    if (preg_match('/^(.*)\s*\.\/([^\.]*)$/', $du_line, $match)) {
        $file_size = format_size($match[1]);
        $username = $match[2];
        $username = trim($username);
        $website = find_site_name($username);
        if ($website) {
            echo "$website | $username | $file_size\n";
        }
    }
}

function find_site_name($username) {
    global $errors;
    $user_file = '/var/cpanel/users/' . $username;
    
    if (!file_exists($user_file)) {
        return false;
    }

    $cmd2 = "/bin/grep DNS= $user_file";
    @exec($cmd2, $match_dns);

    if (count($match_dns) == 1) {
        $website = str_replace('DNS=', '', $match_dns[0]);
        return $website;
    } else {
        print_r($match_dns);exit;
    }

    return false;
}

function format_size($size) {
    if ($size > 1048576) {
        $output = round($size / 1048576, 2) . ' GB';
    } else if ($size > 1024) {
        $output = round($size / 1024, 2) . ' MB';
    } else {
        $output = round($size, 2) . ' KB';
    }
    return $output;
}
