#!/bin/bash

if [ ! -f /usr/local/src/Geekbench-6.1.0-Linux/geekbench6 ]; then
    cd /usr/local/src
    rm -f Geekbench-6.1.0-Linux.tar.gz
    rm -rf Geekbench-6.1.0-Linux
    wget https://cdn.geekbench.com/Geekbench-6.1.0-Linux.tar.gz
    tar xf Geekbench-6.1.0-Linux.tar.gz
    rm -f Geekbench-6.1.0-Linux.tar.gz
fi

/usr/local/src/Geekbench-6.1.0-Linux/geekbench6
