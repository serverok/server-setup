#!/bin/bash

if [ ! -f /root/.ssh/id_rsa.pub ] ; then
    echo "Generating ssh key:"
    /usr/bin/ssh-keygen -t rsa -b 4096 -C "admin@serverOk.in" -N ''
else
    cat ~/.ssh/id_rsa.pub
fi

