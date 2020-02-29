#!/bin/bash

if [ ! -f /usr/local/src/Geekbench-5.1.0-Linux/geekbench5 ]; then
    cd /usr/local/src
    rm -f Geekbench-5.1.0-Linux.tar.gz
    rm -rf Geekbench-5.1.0-Linux
    wget http://cdn.geekbench.com/Geekbench-5.1.0-Linux.tar.gz
    tar xf Geekbench-5.1.0-Linux.tar.gz
fi

/usr/local/src/Geekbench-5.1.0-Linux/geekbench5
