#!/usr/bin/php
<?php
// Author: ServerOK
// Web: https://serverok.in
// Mail: admin@serverok.in
// Backup a web site in Nginx/Apache Server.

if ($argc < 2) {
    echo "Usage: php sok-site-backup.php <domain.tld>\n";
    exit(1);
}

$domainName = $argv[1];
$backupBaseDir = "/usr/serverok/backup";
$siteDataDir = "/usr/serverok/sitedata";
$siteDataFile = "{$siteDataDir}/{$domainName}";

// --- Main Execution ---

// 1. Create a temporary directory for the backup
$timestamp = date('Y-m-d_H-i-s');
$backupTempDir = "{$backupBaseDir}/{$domainName}-{$timestamp}";
if (!mkdir($backupTempDir, 0755, true)) {
    echo "Error: Could not create temporary backup directory {$backupTempDir}\n";
    exit(1);
}
echo "Created temporary backup directory: {$backupTempDir}\n";


// 2. Gather site information
$siteInfo = getSiteInfo($domainName, $siteDataFile);
if (empty($siteInfo)) {
    echo "Error: Could not gather site information for {$domainName}\n";
    cleanupAndExit($backupTempDir);
}
echo "Successfully gathered site information.\n";
print_r($siteInfo);


// 3. Backup files
backupFiles($siteInfo, $backupTempDir);

// 4. Backup database
backupDatabase($siteInfo, $backupTempDir);

// 5. Backup web server config
backupWebServerConfig($siteInfo, $backupTempDir);

// 6. Backup PHP-FPM config
backupPhpFpmConfig($siteInfo, $backupTempDir);

// 7. Compress the final backup
compressBackup($backupTempDir, $backupBaseDir, $domainName, $timestamp);

// 8. Cleanup
cleanupAndExit($backupTempDir, false);

echo "Backup completed successfully!\n";


// --- Functions ---

function getSiteInfo($domainName, $siteDataFile) {
    if (file_exists($siteDataFile)) {
        $data = json_decode(file_get_contents($siteDataFile), true);
        // Add home directory for convenience
        $data['homedir'] = "/home/" . ($data['username'] ?? $domainName);
        return $data;
    }

    echo "Site data file not found. Attempting to infer information...\n";
    
    $username = getUsernameFromHomeDir($domainName);
    if (!$username) {
        return [];
    }

    $phpVersion = findPhpVersionForUser($username);
    if (!$phpVersion) {
        return [];
    }

    return [
        'servername' => $domainName,
        'username' => $username,
        'homedir' => "/home/{$domainName}",
        'documentroot' => "/home/{$domainName}/html",
        'dbname' => "{$username}_db",
        'php_version' => $phpVersion,
    ];
}

function getUsernameFromHomeDir($domainName) {
    $homeDir = "/home/{$domainName}";
    if (!is_dir($homeDir)) {
        echo "Error: Home directory {$homeDir} not found.\n";
        return null;
    }
    $ownerId = fileowner($homeDir);
    $ownerInfo = posix_getpwuid($ownerId);
    if ($ownerInfo) {
        echo "Found username '{$ownerInfo['name']}' from home directory owner.\n";
        return $ownerInfo['name'];
    }
    echo "Error: Could not determine owner of {$homeDir}.\n";
    return null;
}

function findPhpVersionForUser($username) {
    $phpBaseDir = '/etc/php/';
    if (!is_dir($phpBaseDir)) {
        echo "Error: PHP directory {$phpBaseDir} not found.\n";
        return null;
    }

    $phpVersions = scandir($phpBaseDir);
    foreach ($phpVersions as $version) {
        if (is_dir("{$phpBaseDir}/{$version}") && preg_match('/^\d\.\d$/', $version)) {
            $poolFile = "{$phpBaseDir}/{$version}/fpm/pool.d/{$username}.conf";
            if (file_exists($poolFile)) {
                echo "Found PHP version '{$version}' for user '{$username}'.\n";
                return $version;
            }
        }
    }
    echo "Error: Could not find a PHP-FPM pool file for user {$username}.\n";
    return null;
}

function backupFiles($siteInfo, $backupDir) {
    $username = $siteInfo['username'];
    $homeDir = $siteInfo['homedir'];
    $targetFile = "{$backupDir}/files_{$username}.tar.gz";
    
    echo "Backing up files for user '{$username}' from '{$homeDir}'...\n";
    $command = "tar -czpf " . escapeshellarg($targetFile) . " -C " . escapeshellarg(dirname($homeDir)) . " " . escapeshellarg(basename($homeDir));
    shell_exec($command);

    if (file_exists($targetFile)) {
        echo "File backup created successfully.\n";
    } else {
        echo "Error: File backup failed.\n";
    }
}

function backupDatabase($siteInfo, $backupDir) {
    $dbName = $siteInfo['dbname'];
    $targetFile = "{$backupDir}/database_{$dbName}.sql.gz";

    echo "Backing up database '{$dbName}'...\n";
    // Note: This assumes root can connect to MySQL without a password.
    $command = "mysqldump " . escapeshellarg($dbName) . " | gzip > " . escapeshellarg($targetFile);
    shell_exec($command);

    if (file_exists($targetFile) && filesize($targetFile) > 0) {
        echo "Database backup created successfully.\n";
    } else {
        echo "Error: Database backup failed. The file is empty or could not be created.\n";
        // Clean up empty file
        if (file_exists($targetFile)) unlink($targetFile);
    }
}

function backupWebServerConfig($siteInfo, $backupDir) {
    $domainName = $siteInfo['servername'];
    $configBackupDir = "{$backupDir}/config/webserver";
    mkdir($configBackupDir, 0755, true);

    echo "Backing up web server config for '{$domainName}'...\n";
    
    // Check for Nginx
    $nginxConf = "/etc/nginx/sites-enabled/{$domainName}.conf";
    if (file_exists($nginxConf)) {
        copy($nginxConf, "{$configBackupDir}/nginx_{$domainName}.conf");
        echo "Nginx config backed up.\n";
    }

    // Check for Apache
    $apacheConf = "/etc/apache2/sites-enabled/{$domainName}.conf";
    if (file_exists($apacheConf)) {
        copy($apacheConf, "{$configBackupDir}/apache_{$domainName}.conf");
        echo "Apache config backed up.\n";
    }
}

function backupPhpFpmConfig($siteInfo, $backupDir) {
    $username = $siteInfo['username'];
    $phpVersion = $siteInfo['php_version'];
    $configBackupDir = "{$backupDir}/config/php-fpm";
    mkdir($configBackupDir, 0755, true);

    echo "Backing up PHP-FPM config for user '{$username}'...\n";
    $poolFile = "/etc/php/{$phpVersion}/fpm/pool.d/{$username}.conf";
    if (file_exists($poolFile)) {
        copy($poolFile, "{$configBackupDir}/{$username}.conf");
        echo "PHP-FPM config backed up.\n";
    } else {
        echo "Warning: PHP-FPM pool file not found at {$poolFile}.\n";
    }
}

function compressBackup($sourceDir, $targetBaseDir, $domainName, $timestamp) {
    $finalBackupFile = "{$targetBaseDir}/{$domainName}-{$timestamp}.tar.gz";
    echo "Compressing final backup archive to '{$finalBackupFile}'...\n";
    
    $command = "tar -czpf " . escapeshellarg($finalBackupFile) . " -C " . escapeshellarg(dirname($sourceDir)) . " " . escapeshellarg(basename($sourceDir));
    shell_exec($command);

    if (file_exists($finalBackupFile)) {
        echo "Final backup archive created successfully.\n";
    } else {
        echo "Error: Final backup archive creation failed.\n";
    }
}

function cleanupAndExit($tempDir, $exitWithError = true) {
    echo "Cleaning up temporary files...\n";
    shell_exec("rm -rf " . escapeshellarg($tempDir));
    if ($exitWithError) {
        exit(1);
    }
}

?>
