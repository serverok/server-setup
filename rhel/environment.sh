#!/bin/bash

# Copy .vimrc if not exists
if ! [ -f /root/.vimrc ] ; then
    cp ../data/.vimrc /root/.vimrc
fi

if ! grep .bash_hostonnet /root/.bashrc; then
    echo "source /root/.bash_hostonnet" >> /root/.bashrc
fi

if ! [ -f /root/.bash_hostonnet ]; then
    cp ../data/.bash_hostonnet /root/.bash_hostonnet
fi
