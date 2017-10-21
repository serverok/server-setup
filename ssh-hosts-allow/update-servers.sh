#!/bin/bash

scp -P 3333 hosts.allow root@server20.hostonnet.com:/etc/hosts.allow
scp -P 3333 hosts.deny root@server20.hostonnet.com:/etc/hosts.deny

scp -P 3333 hosts.allow root@server46.hostonnet.com:/etc/hosts.allow
scp -P 3333 hosts.deny root@server46.hostonnet.com:/etc/hosts.deny

scp -P 3333 hosts.allow root@server48.hostonnet.com:/etc/hosts.allow
scp -P 3333 hosts.deny root@server48.hostonnet.com:/etc/hosts.deny

scp -P 3333 hosts.allow root@server74.hostonnet.com:/etc/hosts.allow
scp -P 3333 hosts.deny root@server74.hostonnet.com:/etc/hosts.deny

scp -P 3333 hosts.allow root@server78.hostonnet.com:/etc/hosts.allow
scp -P 3333 hosts.deny root@server78.hostonnet.com:/etc/hosts.deny

scp -P 3333 hosts.allow root@server22.hosthat.com:/etc/hosts.allow
scp -P 3333 hosts.deny root@server22.hosthat.com:/etc/hosts.deny