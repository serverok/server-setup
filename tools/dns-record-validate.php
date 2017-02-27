<?php

$records = "
billing     14400   IN  A       198.50.234.185
chat    14400   IN  A      173.199.131.121
support     14400   IN  A       192.99.18.195
helpdesk    14400   IN  A      173.199.135.27
hostonnet.com       158.69.114.170
members     14400   IN  A       173.199.131.121
blog    14400   IN  A      158.69.114.170
radio   14400   IN  A     188.40.131.92
templates   14400   IN  A     158.69.114.170
manage  14400   IN  A        198.50.234.184
ns20    14400   IN  A      158.69.53.72
ns21    14400   IN  A      158.69.114.170
ns74    14400   IN  A      167.114.206.84
ns75    14400   IN  A      167.114.206.85
ns46    14400   IN  A      144.217.43.12
ns47    14400   IN  A      144.217.43.14
ns48    14400   IN  A      198.27.105.230
ns49    14400   IN  A      198.27.105.231
monitor     14400   IN  A       167.114.61.116
ns1     14400   IN  A       162.251.82.251
ns1     14400   IN  A       162.251.82.122
ns1     14400   IN  A       162.251.82.250
ns1     14400   IN  A       162.251.82.123
ns2     14400   IN  A       162.251.82.120
ns2     14400   IN  A       162.251.82.121
ns2     14400   IN  A       162.251.82.249
ns2     14400   IN  A       162.251.82.248
ns3     14400   IN  A       162.251.82.247
ns3     14400   IN  A       162.251.82.246
ns3     14400   IN  A       162.251.82.119
ns3     14400   IN  A       162.251.82.118
ns4     14400   IN  A       162.251.82.124
ns4     14400   IN  A       162.251.82.252
ns4     14400   IN  A       162.251.82.253
ns4     14400   IN  A       162.251.82.125
partner     14400   IN  A       209.99.17.21
dev.manage  14400   IN  A        173.199.135.27
dns10   14400   IN  A     167.114.206.84
dns11   14400   IN  A     167.114.206.85
server20    14400   IN  A      158.69.53.72
server46    14400   IN  A      149.56.240.40
server48    14400   IN  A      192.99.18.195
server74    14400   IN  A      192.99.201.92
server2     14400   IN  A       158.69.124.221
shop    14400   IN  A      209.99.17.23
server70    14400   IN  A      158.69.124.221
vpn     14400   IN  A       198.50.234.187
server78    14400   IN  A      158.69.116.128
149-56-6-88     14400   IN  A       149.56.6.88
149-56-6-89     14400   IN  A       149.56.6.89
ns78    14400   IN  A      149.56.6.90
ns79    14400   IN  A      149.56.6.91
";

$myDomain = 'hostonnet.com';
$myNameServer = 'elle.ns.cloudflare.com';

$recordArray = explode("\n", $records);

foreach ($recordArray as $record) {
    $record = trim($record);
    $record = preg_replace('/\s+/', ' ', $record);
    if (!empty($record)) {
        $recordParts = explode(" ", $record);
        $subDomain = $recordParts[0] . '.' . $myDomain;
        $realIP = nslookup($subDomain, $myNameServer);
        if ($realIP != $recordParts[4]) {
            echo "$subDomain Real IP = $realIP, Needed IP = " . $recordParts[4] . "\n";
        }
    }
}

function nslookup($domainName, $dnsServer = 'localhost') {
    $domainName = trim($domainName);
    $domainName = escapeshellcmd($domainName);
    $dnsServer = trim($dnsServer);
    $dnsServer = escapeshellcmd($dnsServer);
    $cmd = "/usr/bin/nslookup $domainName $dnsServer";
    exec($cmd, $result);
    foreach ($result as $line) {
        if (preg_match('/^Address: (.*)$/', $line, $match)) {
            return trim($match[1]);
        }
    }
    return false;
}
