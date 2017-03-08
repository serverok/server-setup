#!/bin/bash

cd /usr/local/src

if [ ! -f Geekbench-4.0.4-Linux.tar.gz ]; then
    wget http://cdn.primatelabs.com/Geekbench-4.0.4-Linux.tar.gz
fi

if [ -d /usr/local/src/build.pulse ]; then
    rm -rf /usr/local/src/build.pulse
fi

tar xf Geekbench-4.0.4-Linux.tar.gz
/usr/local/src/build.pulse/dist/Geekbench-4.0.4-Linux/geekbench4
