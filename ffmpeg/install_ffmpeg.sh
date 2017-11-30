#!/bin/bash

CFLAGS="-fPIC";export CFLAGS

echo "/usr/lib64/" > /etc/ld.so.conf.d/hostonnet_ffmpeg.conf
echo "/usr/local/lib" >> /etc/ld.so.conf.d/hostonnet_ffmpeg.conf
echo "/usr/lib" >> /etc/ld.so.conf.d/hostonnet_ffmpeg.conf
cat /etc/ld.so.conf.d/hostonnet_ffmpeg.conf
ldconfig


if [ -f /etc/redhat-release ]; then
    yum update
    yum -y upgrade
    yum -y install git
    yum -y install unzip wget bzip2 curl lynx jwhois
    yum -y install nmap patch dos2unix
    yum -y install ncurses-devel automake autoconf
    yum -y install gcc gmake make
    yum -y install libtool libcpp libgcc libstdc++
    yum -y install gcc4 gcc4-c++ gcc4-gfortran
    yum -y install gcc-c++ compat-gcc-32 compat-gcc-32-c++
    yum -y install freetype-devel
fi

if [ -f /etc/lsb-release ]; then
    apt-get -y install autotools-dev
    apt -y install lynx nmap libncurses5-dev libncurses5 dos2unix
    apt -y install autoconf automake build-essential git libass-dev
    apt -y install libtool
fi

mkdir -p /usr/local/src/hostonnet/tmp
chmod 777 /usr/local/src/hostonnet/tmp
export TMPDIR=/usr/local/src/hostonnet/tmp

if [ -f /usr/local/cpanel/version ];
then
    /scripts/installruby
else
    yum -y install ruby
fi

cd /usr/local/src/hostonnet/
wget -c http://www.ijg.org/files/jpegsrc.v9a.tar.gz
tar xvf jpegsrc.v9a.tar.gz
cd /usr/local/src/hostonnet/jpeg-*
./configure  --prefix=/usr
make
make install

# https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

cd /usr/local/src/hostonnet/
wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master
tar xzvf fdk-aac.tar.gz
cd /usr/local/src/hostonnet/mstorsjo-fdk-aac*
make distclean
autoreconf -fiv
./configure --prefix=/usr
make && make install

if [ $? -ne 0 ]; then
    echo "fdk-aac failed to install"
    exit 1
fi

ldconfig

# http://sourceforge.net/projects/faac/files/

cd /usr/local/src/hostonnet/
wget -c http://downloads.sourceforge.net/project/faac/faac-src/faac-1.28/faac-1.28.tar.gz
tar -zxvf faac-1.28.tar.gz
cd /usr/local/src/hostonnet/faac*
sed -i '/char \*strcasestr(const char \*haystack, const char \*needle);/d' ./common/mp4v2/mpeg4ip.h
./bootstrap
./configure --prefix=/usr
make && make install

if [ $? -ne 0 ]; then
    echo "faac-src failed to install"
    exit 1
fi

ldconfig

cd /usr/local/src/hostonnet/
wget -c http://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.7/faad2-2.7.tar.gz
tar -zxvf faad2-2.7.tar.gz
cd /usr/local/src/hostonnet/faad2*
autoreconf -vif
./configure --prefix=/usr
make && make install

if [ $? -ne 0 ]; then
    echo "faad2 failed to install"
    exit 1
fi


# https://xiph.org/downloads/

cd /usr/local/src/hostonnet/
wget -c http://downloads.xiph.org/releases/ogg/libogg-1.3.3.tar.gz
tar zxvf libogg-1.3.3.tar.gz
cd /usr/local/src/hostonnet/libogg-1.3.3
./configure && make && make install

if [ $? -ne 0 ]; then
    echo "libogg failed to install"
    exit 1
fi


ldconfig

# http://www.xiph.org/downloads/

cd /usr/local/src/hostonnet/
wget -c http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.gz
tar zxvf libvorbis-1.3.5.tar.gz
cd /usr/local/src/hostonnet/libvorbis-1.3.5
./configure && make && make install

if [ $? -ne 0 ]; then
    echo "libvorbis failed to install"
    exit 1
fi

# http://www.xiph.org/downloads/

cd /usr/local/src/hostonnet/
wget -c http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2
tar xf libtheora-1.1.1.tar.bz2
cd /usr/local/src/hostonnet/libtheora-1.1.1
./configure --prefix=/usr
make && make install

if [ $? -ne 0 ]; then
    echo "libtheora failed to install"
    exit 1
fi


# http://lame.sourceforge.net/download.php

cd /usr/local/src/hostonnet/
wget -c http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
tar xf lame-3.100.tar.gz
cd /usr/local/src/hostonnet/lame-3.100
./configure --enable-shared --prefix=/usr
make && make install

# http://www.xvid.org/Downloads.43.0.html

cd /usr/local/src/hostonnet/
wget -c http://downloads.xvid.org/downloads/xvidcore-1.3.4.tar.gz
tar xvf xvidcore-1.3.4.tar.gz
cd /usr/local/src/hostonnet/xvidcore/build/generic/
./configure --prefix=/usr && make && make install

# http://rubyforge.org/projects/flvtool2/
# http://www.inlet-media.de/2009/11/flvtool2.html

cd /usr/local/src/hostonnet/
wget https://github.com/unnu/flvtool2/archive/master.zip -O flvtool2.zip
unzip flvtool2.zip
cd /usr/local/src/hostonnet/flvtool2-master/
ruby setup.rb config --prefix=/usr
ruby setup.rb setup
ruby setup.rb install

# http://yamdi.sourceforge.net/

cd /usr/local/src/hostonnet/
wget -c http://downloads.sourceforge.net/project/yamdi/yamdi/1.9/yamdi-1.9.tar.gz
tar -zxvf yamdi-1.9.tar.gz
cd /usr/local/src/hostonnet/yamdi-1.9
gcc yamdi.c -o yamdi -O2 -Wall
mv yamdi /usr/bin/

#cd /usr/local/src
#git clone https://github.com/ioppermann/yamdi.git

cd /usr/local/src/hostonnet/
wget -c http://liba52.sourceforge.net/files/a52dec-0.7.4.tar.gz
tar xvf a52dec-0.7.4.tar.gz
cd /usr/local/src/hostonnet/a52dec*
./configure
make && make install

# http://www.penguin.cz/~utx/amr#download

cd /usr/local/src/hostonnet/
wget -c ftp://ftp.penguin.cz/pub/users/utx/amr/amrnb-11.0.0.0.tar.bz2
tar jxvf amrnb-11.0.0.0.tar.bz2
cd /usr/local/src/hostonnet/amrnb-11.0.0.0
./configure
make && make install

cd /usr/local/src/hostonnet/
wget -c ftp://ftp.penguin.cz/pub/users/utx/amr/amrwb-11.0.0.0.tar.bz2
tar jxvf amrwb-11.0.0.0.tar.bz2
cd /usr/local/src/hostonnet/amrwb-11.0.0.0
./configure
make && make install

# http://yasm.tortall.net/Download.html
# 23-Oct-2015 09:01 AM
# yasm --version

cd /usr/local/src/hostonnet/
git clone git://github.com/yasm/yasm.git
cd /usr/local/src/hostonnet/yasm
./autogen.sh
./configure --prefix=/usr
make && make install

# nasm needed for x264
cd /usr/local/src/hostonnet/
wget http://www.nasm.us/pub/nasm/releasebuilds/2.14rc0/nasm-2.14rc0.tar.xz
tar xf nasm-2.14rc0.tar.xz
cd /usr/local/src/hostonnet/nasm-2.14rc0/
./configure --prefix=/usr
make && make install

# http://www.videolan.org/developers/x264.html
# x264 --help

cd /usr/local/src/hostonnet/
git clone git://git.videolan.org/x264.git
cd /usr/local/src/hostonnet/x264/
git pull
make clean && make distclean
./configure --prefix=/usr --enable-shared
make && make install

# 32bit versions needed for neroAacEnc
yum -y install glibc.i686 libstdc++.i686

cd /usr/local/src/hostonnet/
wget -c http://ftp6.nero.com/tools/NeroDigitalAudio.zip
unzip NeroDigitalAudio.zip -d nero
cd /usr/local/src/hostonnet/nero/linux
install -D -m755 neroAacEnc /usr/bin

# https://gpac.wp.mines-telecom.fr/
# 2017-11-18

cd /usr/local/src/hostonnet/
wget https://github.com/gpac/gpac/archive/v0.7.1.tar.gz
tar xf v0.7.1.tar.gz
cd /usr/local/src/hostonnet/gpac-0.7.1
./configure --prefix=/usr
make
make install

# https://mediaarea.net/en/MediaInfo/Download/Source
# 2017-11-18

cd /usr/local/src/hostonnet/
wget https://mediaarea.net/download/binary/mediainfo/17.10/MediaInfo_CLI_17.10_GNU_FromSource.tar.gz
tar xf MediaInfo_CLI_17.10_GNU_FromSource.tar.gz
cd /usr/local/src/hostonnet/MediaInfo_CLI_GNU_FromSource
./CLI_Compile.sh --prefix=/usr
cd /usr/local/src/hostonnet/MediaInfo_CLI_GNU_FromSource/MediaInfo/Project/GNU/CLI
make install

# http://sourceforge.net/projects/libdc1394/files/?source=navbar
# updated on 12-May-2015 09:32 AM

cd /usr/local/src/hostonnet/
wget -c http://downloads.sourceforge.net/project/libdc1394/libdc1394-2/2.2.4/libdc1394-2.2.4.tar.gz
tar zxfv libdc1394-2.2.4.tar.gz
cd /usr/local/src/hostonnet/libdc1394-2.2.4
make clean && make distclean
./configure
make
make install

# http://www.mplayerhq.hu/design7/dload.html
# Updated on 2017-08-09

cd /usr/local/src/hostonnet/
wget http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.3.0.tar.xz
tar xvf MPlayer-1.3.0.tar.xz
cd /usr/local/src/hostonnet/MPlayer-1.3.0
echo y | ./configure --prefix=/usr --codecsdir=/usr/local/lib/codecs/ --enable-theora
make && make install


cd /usr/local/src/hostonnet/
wget -c http://www.mplayerhq.hu/MPlayer/releases/codecs/all-20071007.tar.bz2
tar -jxvf all-20071007.tar.bz2
cd /usr/local/src/hostonnet/all-20071007
mv /usr/local/lib/codecs /usr/local/lib/codecs-$(date +%m%d%Y%H%N)
mkdir -p /usr/local/lib/codecs
cp -f *.* /usr/local/lib/codecs/
chmod -R 755 /usr/local/lib/codecs/
ls -l /usr/local/lib/codecs/
ln -sf /usr/local/lib/codecs /usr/lib/codecs
ln -sf /usr/local/lib/codecs /usr/local/lib/win32
ln -sf /usr/local/lib/codecs /usr/lib/win32
ldconfig


# https://www.webmproject.org/code/
# https://github.com/webmproject/libvpx/releases
# cmd = vpxenc

cd /usr/local/src/hostonnet/
wget https://github.com/webmproject/libvpx/archive/v1.6.1.tar.gz -O libvpx.tar.gz
tar xvf libvpx.tar.gz
cd /usr/local/src/hostonnet/libvpx-*
make clean && make distclean
./configure --prefix=/usr --enable-shared
make
make install


# https://github.com/FFmpeg/FFmpeg/releases
# Updated on 2016-10-13

cd /usr/local/src/hostonnet/
wget https://github.com/FFmpeg/FFmpeg/archive/n3.3.5.tar.gz
tar zxf n3.3.5.tar.gz
cd /usr/local/src/hostonnet/FFmpeg-n3.3.5/
make clean && make distclean
./configure --prefix=/usr --enable-shared --enable-libxvid --enable-libvorbis --enable-libtheora --enable-libmp3lame --enable-gpl --enable-libfdk-aac --enable-nonfree --enable-libx264 --enable-libfreetype
make && make install && ldconfig

cd /usr/local/src/hostonnet/FFmpeg-n3.3.5/
make tools/qt-faststart
cp -a tools/qt-faststart /usr/bin/

ldconfig
