<?php
####################################################
# Author: ServerOK Software
# Web: https://serverok.in
####################################################

$do = isset($_GET['do']) ? $_GET['do'] : '';

$toEmail = "admin@serverok.in";

if ($do == 'mail') {
    $headers = 'From: admin@serverok.in' . "\r\n" .
    'Reply-To: admin@serverok.in' . "\r\n" .
    'X-Mailer: PHP/' . phpversion();
    mail($toEmail, "test email", "testing");
    echo "mail sent to $toEmail at " . time();
} else if ($do == 'info') {
    phpinfo();
} else {
    echo "Welcome";
}
