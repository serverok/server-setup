<?php

$host = "smtp.sendgrid.net";
$port = 2525;

if (!$socket = @fsockopen($host, $port, $errno, $errstr, 3)) {
    echo "Port $port is CLOSED or OFFLINE";
}  else {
    echo "Port $port is OPEN";
    fclose($socket);
}
