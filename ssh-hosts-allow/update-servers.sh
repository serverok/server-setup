#!/bin/bash

proxychains scp -P 3333 hosts.allow root@server20.hostonnet.com:/etc/hosts.allow
proxychains scp -P 3333 hosts.deny root@server20.hostonnet.com:/etc/hosts.deny

proxychains scp -P 3333 hosts.allow root@server46.hostonnet.com:/etc/hosts.allow
proxychains scp -P 3333 hosts.deny root@server46.hostonnet.com:/etc/hosts.deny

proxychains scp -P 3333 hosts.allow root@server48.hostonnet.com:/etc/hosts.allow
proxychains scp -P 3333 hosts.deny root@server48.hostonnet.com:/etc/hosts.deny

proxychains scp -P 3333 hosts.allow root@server74.hostonnet.com:/etc/hosts.allow
proxychains scp -P 3333 hosts.deny root@server74.hostonnet.com:/etc/hosts.deny

proxychains scp -P 3333 hosts.allow root@server78.hostonnet.com:/etc/hosts.allow
proxychains scp -P 3333 hosts.deny root@server78.hostonnet.com:/etc/hosts.deny

proxychains scp -P 3333 hosts.allow root@server22.hosthat.com:/etc/hosts.allow
proxychains scp -P 3333 hosts.deny root@server22.hosthat.com:/etc/hosts.deny

proxychains scp -P 3333 hosts.allow root@server24.hostonnet.com:/etc/hosts.allow
proxychains scp -P 3333 hosts.deny root@server24.hostonnet.com:/etc/hosts.deny
