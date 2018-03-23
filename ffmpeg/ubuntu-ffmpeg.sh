#!/bin/bash

apt -y install lynx nmap libncurses5-dev libncurses5 dos2unix
apt -y install autoconf automake build-essential git libass-dev libgpac-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libx11-dev libxext-dev libxfixes-dev pkg-config texi2html zlib1g-dev
apt -y install libmp3lame-dev libxvidcore-dev
apt -y install cmake mercurial

cd /usr/local/src
wget http://www.nasm.us/pub/nasm/releasebuilds/2.14rc0/nasm-2.14rc0.tar.xz
tar xf nasm-2.14rc0.tar.xz
cd nasm-2.14rc0/
./configure --prefix=/usr
make
make install

cd /usr/local/src
wget -c http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar zfvx yasm-1.3.0.tar.gz
cd /usr/local/src/yasm-1.3.0
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
hg clone https://bitbucket.org/multicoreware/x265
cd x265/build/linux
cmake -G "Unix Makefiles" -DENABLE_SHARED:bool=off ../../source
make
make install

apt-get install libvpx-dev

cd /usr/local/src
git clone git://github.com/mstorsjo/fdk-aac.git
cd /usr/local/src/fdk-aac
make clean && make distclean
autoreconf -fiv
./configure --prefix=/usr --enable-shared
make
make install

apt-get install libopus-dev

cd /usr/local/src
git clone git://source.ffmpeg.org/ffmpeg
cd /usr/local/src/ffmpeg
make clean && make distclean
./configure --prefix=/usr  --enable-gpl  --enable-libfdk-aac --enable-libmp3lame   --enable-libtheora --enable-libvorbis --enable-libx264 --enable-nonfree

./configure --prefix=/usr  --enable-gpl  --enable-libfdk-aac --enable-libx264 --enable-nonfree

./configure \
  --prefix=/usr \
  --extra-libs=-lpthread \
  --pkg-config-flags="--static" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree


make
make install
ldconfig

hash -r

