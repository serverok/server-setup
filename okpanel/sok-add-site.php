#!/usr/bin/php
<?php
// Author: ServerOK
// Web: https://serverok.in
// Mail: admin@serverok.in
// Create web site in Nginx/Apache Server.


function verifyPhpVersion($phpVersion) {
    $phpSocket = "/var/run/php/php" . $phpVersion . "-fpm.sock";
    if (!file_exists($phpSocket)) {
        echo "ERROR: PHP version {$phpVersion} not found. Missing socket {$phpSocket}\n";
        exit(1);
    }
    return true;
}

function generatePassword() {
    $passwordChars = "abcdefghjkmnpqrstuvwxyz234567890";
    $myPassword = "";
    $haveNumber = false;
    for ($i = 0; $i < 20; $i++) {
        $nextIndex = rand(0, strlen($passwordChars) - 1);
        if ($i < 2) {
            $nextIndex = rand(0, 9);
            $myChar = strtoupper($passwordChars[$nextIndex]);
        } elseif (rand(0, 10) > 5) {
            $myChar = strtoupper($passwordChars[$nextIndex]);
        } else {
            $myChar = $passwordChars[$nextIndex];
        }
        if ($i == 17) {
            if (!$haveNumber) {
                $myChar = (string)rand(0, 9);
            }
        }
        if (is_numeric($myChar)) {
            $haveNumber = true;
        }
        $myPassword .= $myChar;
    }
    return $myPassword;
}

function verifyDomain($domainName) {
    if (!preg_match("/^([A-Za-z0-9-\\.]+)$/", $domainName)) {
        echo "Invalid domain name: {$domainName}\n";
        exit(1);
    }
}

function verifyPassword($password) {
    if (!preg_match("/^([A-Za-z0-9-\\.]+)$/", $password)) {
        echo "Invalid password: {$password}\n";
        exit(1);
    }
}

function verifyUsername($username) {
    if (strlen($username) > 32) {
        echo "Error: username must be less than 32 chars\n";
        exit(1);
    }
    if (!preg_match("/^([A-Za-z0-9]+)$/", $username)) {
        echo "Invalid user name {$username}\n";
        exit(1);
    }
}

function linuxUserExists($username) {
    return posix_getpwnam($username) !== false;
}

function linuxAddUser($domainName, $username, $password) {
    $encPass = crypt($password, "22");
    shell_exec("useradd -m -s /bin/bash -d /home/{$domainName}/ -p " . escapeshellarg($encPass) . " " . escapeshellarg($username));
}

function getUrlContent($url) {
    $content = file_get_contents($url);
    if ($content === false) {
        echo "Failed to get content from {$url}\n";
        exit(1);
    }
    return $content;
}

function createPhpfpmConfig($username, $phpVersion) {
    $content = getUrlContent("https://raw.githubusercontent.com/serverok/server-setup/master/config/nginx/php-fpm-pool.txt");
    $content = str_replace("POOL_NAME", $username, $content);
    $content = str_replace("FPM_USER", $username, $content);
    $fileLocation = "/etc/php/{$phpVersion}/fpm/pool.d/{$username}.conf";
    file_put_contents($fileLocation, $content);
}

function createNginxConfig($domainName, $username, $appType) {
    if ($appType == "laravel") {
        $content = getUrlContent("https://raw.githubusercontent.com/serverok/server-setup/master/config/nginx/vhosts/nginx-laravel-vhost-ssl.txt");
    } else {
        $content = getUrlContent("https://raw.githubusercontent.com/serverok/server-setup/master/config/nginx/vhosts/nginx-vhost-ssl.txt");
    }
    $content = str_replace("POOL_NAME", $username, $content);
    $content = str_replace("FQDN", $domainName, $content);
    $fileLocation = "/etc/nginx/sites-enabled/{$domainName}.conf";
    file_put_contents($fileLocation, $content);
}

function createApacheConfig($domainName, $username, $appType) {
    if ($appType == "laravel") {
        $content = getUrlContent("https://raw.githubusercontent.com/serverok/server-setup/master/config/apache/vhost-laravel.conf");
    } else {
        $content = getUrlContent("https://raw.githubusercontent.com/serverok/server-setup/master/config/apache/vhost.conf");
    }
    $content = str_replace("POOL_NAME", $username, $content);
    $content = str_replace("FQDN", $domainName, $content);
    $fileLocation = "/etc/apache2/sites-enabled/{$domainName}.conf";
    file_put_contents($fileLocation, $content);
}

function detectServer() {
    $output = shell_exec('ss -nltp');
    if ($output === null) {
        echo "Error executing ss command\n";
        exit(1);
    }

    $outputStr = strtolower($output);

    if (strpos($outputStr, '*:80') !== false || strpos($outputStr, '0.0.0.0:80') !== false) {
        if (strpos($outputStr, 'apache2') !== false) {
            return "apache";
        }
        if (strpos($outputStr, 'nginx') !== false) {
            return "nginx";
        }
    }
    
    echo "Error: Neither Apache nor Nginx is listening on port 80 or 443.\n";
    exit(1);
}

function findIp() {
    $ip = file_get_contents("http://checkip.amazonaws.com");
    if ($ip === false) {
        echo "Failed to find IP address\n";
        exit(1);
    }
    return trim($ip);
}

function createSiteDataFile($domainName, $username, $docRoot, $phpVersion, $appType) {
    $sitedataDir = "/usr/serverok/sitedata/";
    if (!is_dir($sitedataDir)) {
        mkdir($sitedataDir, 0755, true);
    }

    $data = [
        'servername' => $domainName,
        'serveralias' => 'www.' . $domainName,
        'documentroot' => $docRoot,
        'username' => $username,
        'dbname' => $username . '_db',
        'creation_date' => date('Y-m-d H:i:s'),
        'php_version' => $phpVersion,
        'app_type' => $appType,
    ];

    $jsonData = json_encode($data, JSON_PRETTY_PRINT);
    $filePath = $sitedataDir . $domainName;
    file_put_contents($filePath, $jsonData);
}

function createMysqlDatabaseAndUser($username, $passwordMysql) {
    $dbName = $username . '_db';
    $dbUser = $username . '_db';

    // Connect to MySQL as root (passwordless)
    $mysqli = new mysqli('localhost', 'root', '');
    if ($mysqli->connect_error) {
        echo "MySQL Connection failed: " . $mysqli->connect_error . "\n";
        exit(1);
    }

    // Create Database
    if (!$mysqli->query("CREATE DATABASE `{$dbName}`")) {
        echo "Error creating database {$dbName}: " . $mysqli->error . "\n";
        $mysqli->close();
        exit(1);
    }

    // Create User
    if (!$mysqli->query("CREATE USER '{$dbUser}'@'localhost' IDENTIFIED BY '{$passwordMysql}'")) {
        echo "Error creating user {$dbUser}: " . $mysqli->error . "\n";
        $mysqli->close();
        exit(1);
    }

    // Grant Privileges
    if (!$mysqli->query("GRANT ALL PRIVILEGES ON `{$dbName}`.* TO '{$dbUser}'@'localhost'")) {
        echo "Error granting privileges to {$dbUser}: " . $mysqli->error . "\n";
        $mysqli->close();
        exit(1);
    }

    $mysqli->query("FLUSH PRIVILEGES");
    $mysqli->close();
    echo "Successfully created MySQL database and user.\n";
}

$text = 'ServerOK Nginx Manager.';

$options = getopt("d:u:p:", ["domain:", "user:", "password:", "php:", "app:"]);

if (isset($options['d'])) {
    $domainName = trim($options['d']);
} elseif (isset($options['domain'])) {
    $domainName = trim($options['domain']);
} else {
    $domainName = trim(readline("Enter domain name: "));
}

if (isset($options['u'])) {
    $username = $options['u'];
} elseif (isset($options['user'])) {
    $username = $options['user'];
} else {
    echo "ERROR: Please specify username with -u or --user option.\n";
    exit(1);
}

if (isset($options['p'])) {
    $password = $options['p'];
} elseif (isset($options['password'])) {
    $password = $options['password'];
} else {
    $password = generatePassword();
}

if (isset($options['php'])) {
    $phpVersion = $options['php'];
} else {
    echo "ERROR: Please specify PHP version with --php option.\n";
    exit(1);
}

$appType = "wp";
if (isset($options['app'])) {
    $appType = trim($options['app']);
    if ($appType != "laravel") {
        $appType = "wp";
    }
}

$server = detectServer();
echo "Server = {$server}\n";

verifyPhpVersion($phpVersion);
verifyUsername($username);
verifyDomain($domainName);
verifyPassword($password);

if (linuxUserExists($username)) {
    echo "ERROR: User {$username} already exists!\n";
    exit(1);
}

$passwordMysql = generatePassword();
createMysqlDatabaseAndUser($username, $passwordMysql);
$ipAddress = findIp();

linuxAddUser($domainName, $username, $password);

createPhpfpmConfig($username, $phpVersion);

if ($server == "nginx") {
    createNginxConfig($domainName, $username, $appType);
} else {
    createApacheConfig($domainName, $username, $appType);
}

$docRoot = "/home/{$domainName}/html/";
shell_exec("mkdir -p " . escapeshellarg($docRoot));
shell_exec("chown -R " . escapeshellarg($username) . ":" . escapeshellarg($username) . " " . escapeshellarg($docRoot));
shell_exec("chmod -R 750 " . escapeshellarg("/home/{$domainName}"));
shell_exec("usermod -aG " . escapeshellarg($username) . " www-data");
shell_exec("openssl genrsa -out /etc/ssl/{$domainName}.key 2048");
shell_exec("openssl req -new -x509 -key /etc/ssl/{$domainName}.key -out /etc/ssl/{$domainName}.crt -days 3650 -subj /CN={$domainName}");

if ($appType == "laravel") {
    $docRoot = "/home/{$domainName}/html/public/";
    shell_exec("mkdir -p " . escapeshellarg($docRoot));
    shell_exec("chown -R " . escapeshellarg($username) . ":" . escapeshellarg($username) . " " . escapeshellarg($docRoot));
}

shell_exec("systemctl restart php{$phpVersion}-fpm");

if ($server == "nginx") {
    shell_exec("systemctl restart nginx");
} else {
    shell_exec("systemctl restart apache2");
}

createSiteDataFile($domainName, $username, $docRoot, $phpVersion, $appType);

echo "SFTP {$domainName}\n\n";
echo "IP = {$ipAddress}\n";
echo "Port = 22\n";
echo "User = {$username}\n";
echo "PW = {$password}\n\n";

echo "MySQL\n\n";

echo "DB = {$username}_db\n";
echo "User = {$username}_db\n";
echo "PW = {$passwordMysql}\n\n";

echo "phpMyAdmin\n\n";

echo "http://{$ipAddress}:7777\n";
echo "User = {$username}_db\n";
echo "PW = {$passwordMysql}\n\n";

if ($server == "nginx") {
    echo "certbot --authenticator webroot --webroot-path " . escapeshellarg($docRoot) . " --installer nginx -m admin@serverok.in --agree-tos --no-eff-email -d {$domainName} -d www.{$domainName}\n";
} else {
    echo "certbot --authenticator webroot --webroot-path " . escapeshellarg($docRoot) . " --installer apache -m admin@serverok.in --agree-tos --no-eff-email -d {$domainName} -d www.{$domainName}\n";
}

?>
