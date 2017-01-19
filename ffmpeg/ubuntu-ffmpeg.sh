#!/bin/bash

apt -y install lynx nmap libncurses5-dev libncurses5 dos2unix
apt -y install autoconf automake build-essential git libass-dev libgpac-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libx11-dev libxext-dev libxfixes-dev pkg-config texi2html zlib1g-dev
apt -y install libmp3lame-dev libxvidcore-dev

cd /usr/local/src
wget -c http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
tar zfvx yasm-1.2.0.tar.gz
cd /usr/local/src/yasm-1.2.0
./configure
make && make install

cd /usr/local/src
git clone git://git.videolan.org/x264.git
cd /usr/local/src/x264/
git pull
make clean && make distclean
./configure --prefix=/usr --enable-shared
make && make install

cd /usr/local/src
git clone git://github.com/mstorsjo/fdk-aac.git
cd /usr/local/src/fdk-aac
make clean && make distclean
autoreconf -fiv
./configure --prefix=/usr --enable-shared
make
make install


cd /usr/local/src
git clone git://source.ffmpeg.org/ffmpeg
cd /usr/local/src/ffmpeg
make clean && make distclean
./configure --prefix=/usr  --enable-gpl  --enable-libfdk-aac --enable-libmp3lame   --enable-libtheora --enable-libvorbis --enable-libx264 --enable-nonfree

./configure --prefix=/usr  --enable-gpl  --enable-libfdk-aac --enable-libx264 --enable-nonfree

make
make install
ldconfig

hash -r

