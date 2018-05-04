#!/bin/bash

# Copy .vimrc if not exists
if ! [ -f /root/.vimrc ] ; then
    cp ../data/.vimrc /root/.vimrc
fi

if ! grep .bash_serverok /root/.bashrc; then
    echo "source /root/.bash_serverok" >> /root/.bashrc
fi

if ! [ -f /root/.bash_serverok ]; then
    if [ -f ../data/.bash_serverok ]; then
        cp ../data/.bash_serverok /root/.bash_serverok
    else
        touch /root/.bash_serverok
    fi
fi
