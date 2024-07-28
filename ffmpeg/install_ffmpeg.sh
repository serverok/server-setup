#!/bin/bash

CFLAGS="-fPIC";export CFLAGS

echo "/usr/lib64/" > /etc/ld.so.conf.d/serverok_ffmpeg.conf
echo "/usr/local/lib" >> /etc/ld.so.conf.d/serverok_ffmpeg.conf
echo "/usr/lib" >> /etc/ld.so.conf.d/serverok_ffmpeg.conf
cat /etc/ld.so.conf.d/serverok_ffmpeg.conf
ldconfig


if [ -f /etc/redhat-release ]; then
    yum -y update
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

mkdir -p /usr/local/src/tmp
chmod 777 /usr/local/src/tmp
export TMPDIR=/usr/local/src/tmp

yum -y install ruby


cd /usr/local/src/
wget -c http://www.ijg.org/files/jpegsrc.v9a.tar.gz
tar xvf jpegsrc.v9a.tar.gz
cd /usr/local/src/jpeg-*
./configure  --prefix=/usr
make
make install

# https://github.com/mstorsjo/fdk-aac/releases

cd /usr/local/src/
wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/archive/v2.0.1.tar.gz
tar xzvf fdk-aac.tar.gz
cd /usr/local/src/fdk-aac-2.0.1
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

cd /usr/local/src/
wget -c https://downloads.sourceforge.net/project/faac/faac-src/faac-1.30/faac-1_30.tar.gz
tar -zxvf faac-1_30.tar.gz
cd /usr/local/src/faac-1_30
sed -i '/char \*strcasestr(const char \*haystack, const char \*needle);/d' ./common/mp4v2/mpeg4ip.h
./bootstrap
./configure --prefix=/usr
make && make install

if [ $? -ne 0 ]; then
    echo "faac-src failed to install"
    exit 1
fi

ldconfig

# https://github.com/knik0/faad2

cd /usr/local/src/
wget https://github.com/knik0/faad2/archive/2_9_2.tar.gz -O faad2.tar.gz
tar -zxvf faad2.tar.gz
cd /usr/local/src/faad2-2_9_2
autoreconf -vif
./configure --prefix=/usr
make && make install

if [ $? -ne 0 ]; then
    echo "faad2 failed to install"
    exit 1
fi


# https://xiph.org/downloads/

cd /usr/local/src/
wget -c http://downloads.xiph.org/releases/ogg/libogg-1.3.4.tar.gz
tar zxvf libogg-1.3.4.tar.gz
cd /usr/local/src/libogg-1.3.4
./configure --prefix=/usr
make
make install

if [ $? -ne 0 ]; then
    echo "libogg failed to install"
    exit 1
fi


ldconfig

# http://www.xiph.org/downloads/

cd /usr/local/src/
wget -c http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.6.tar.gz
tar zxvf libvorbis-1.3.6.tar.gz
cd /usr/local/src/libvorbis-1.3.6
./configure --prefix=/usr
make
make install

if [ $? -ne 0 ]; then
    echo "libvorbis failed to install"
    exit 1
fi

# http://www.xiph.org/downloads/

cd /usr/local/src/
wget -c http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2
tar xvf libtheora-1.1.1.tar.bz2
cd /usr/local/src/libtheora-1.1.1
./configure --prefix=/usr
make
make install

# For CentOS 8
# 2022-01-12  commit 7180717276af1ebc7da15c83162d6c5d6203aabf

cd /usr/local/src
git clone https://gitlab.xiph.org/xiph/theora.git
cd theora
./autogen.sh
./configure --prefix=/usr
make
make install


if [ $? -ne 0 ]; then
    echo "libtheora failed to install"
    exit 1
fi


# http://lame.sourceforge.net/download.php

cd /usr/local/src/
wget -c http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
tar xf lame-3.100.tar.gz
cd /usr/local/src/lame-3.100
./configure --enable-shared --prefix=/usr
make
make install

if [ $? -ne 0 ]; then
    echo "faac-src failed to install"
    exit 1
fi

# http://www.xvid.org/Downloads.43.0.html

cd /usr/local/src/
wget -c http://downloads.xvid.org/downloads/xvidcore-1.3.4.tar.gz
tar xvf xvidcore-1.3.4.tar.gz
cd /usr/local/src/xvidcore/build/generic/
./configure --prefix=/usr
make
make install

if [ $? -ne 0 ]; then
    echo "faac-src failed to install"
    exit 1
fi

# http://rubyforge.org/projects/flvtool2/
# http://www.inlet-media.de/2009/11/flvtool2.html
# https://www.serverok.in/install-ruby-from-source

gem install flvtool2
ln -s /usr/local/bin/flvtool2 /usr/bin/flvtool2

if [ $? -ne 0 ]; then
    echo "faac-src failed to install"
    exit 1
fi

# http://yamdi.sourceforge.net/

cd /usr/local/src/
wget -c http://downloads.sourceforge.net/project/yamdi/yamdi/1.9/yamdi-1.9.tar.gz
tar -zxvf yamdi-1.9.tar.gz
cd /usr/local/src/yamdi-1.9
gcc yamdi.c -o yamdi -O2 -Wall
mv yamdi /usr/bin/

#cd /usr/local/src
#git clone https://github.com/ioppermann/yamdi.git

cd /usr/local/src/
wget -c http://liba52.sourceforge.net/files/a52dec-0.7.4.tar.gz
tar xvf a52dec-0.7.4.tar.gz
cd /usr/local/src/a52dec-0.7.4
./configure
make
make install

if [ $? -ne 0 ]; then
    echo "faac-src failed to install"
    exit 1
fi

# http://www.penguin.cz/~utx/amr#download

cd /usr/local/src/
wget -c ftp://ftp.penguin.cz/pub/users/utx/amr/amrnb-11.0.0.0.tar.bz2
tar jxvf amrnb-11.0.0.0.tar.bz2
cd /usr/local/src/amrnb-11.0.0.0
./configure
make
make install

if [ $? -ne 0 ]; then
    echo "faac-src failed to install"
    exit 1
fi

cd /usr/local/src/
wget -c ftp://ftp.penguin.cz/pub/users/utx/amr/amrwb-11.0.0.0.tar.bz2
tar jxvf amrwb-11.0.0.0.tar.bz2
cd /usr/local/src/amrwb-11.0.0.0
./configure
make
make install

if [ $? -ne 0 ]; then
    echo "amrwb failed to install"
    exit 1
fi

# http://yasm.tortall.net/Download.html
# 23-Oct-2015 09:01 AM
# yasm --version

cd /usr/local/src/
wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xvf yasm-1.3.0.tar.gz
cd /usr/local/src/yasm-1.3.0
./autogen.sh
./configure --prefix=/usr
make
make install

if [ $? -ne 0 ]; then
    echo "yasm failed to install"
    exit 1
fi

# nasm needed for x264
cd /usr/local/src/
wget https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.xz
tar xvf nasm-2.14.02.tar.xz
cd /usr/local/src/nasm-2.14.02/
./configure --prefix=/usr
make
make install

if [ $? -ne 0 ]; then
    echo "nasm failed to install"
    exit 1
fi

# http://www.videolan.org/developers/x264.html
# x264 --help
# 7817004df0bf57e1eb83e8ef9c0c407477b59d71 Fri Nov 1 10:00:11 2019 +0100

cd /usr/local/src/
git clone https://code.videolan.org/videolan/x264.git
cd x264
make clean && make distclean
./configure --prefix=/usr --enable-shared
make 
make install

if [ $? -ne 0 ]; then
    echo "x264 failed to install"
    exit 1
fi

# https://gpac.wp.mines-telecom.fr/
# 2019-12-11
# https://github.com/gpac/gpac/releases
# /usr/bin/MP4Box

cd /usr/local/src
wget https://github.com/gpac/gpac/archive/v1.0.1.tar.gz -O gpac.tar.gz
tar vxf gpac.tar.gz
cd gpac-1.0.1
./configure --prefix=/usr
make
make install

if [ $? -ne 0 ]; then
    echo "gpac failed to install"
    exit 1
fi


# https://mediaarea.net/en/MediaInfo/Download/Source
# 2019-12-11

cd /usr/local/src/
wget https://mediaarea.net/download/binary/mediainfo/20.03/MediaInfo_CLI_20.03_GNU_FromSource.tar.gz
tar xvf MediaInfo_CLI_20.03_GNU_FromSource.tar.gz
cd /usr/local/src/MediaInfo_CLI_GNU_FromSource
./CLI_Compile.sh --prefix=/usr
cd /usr/local/src/MediaInfo_CLI_GNU_FromSource/MediaInfo/Project/GNU/CLI
make install

if [ $? -ne 0 ]; then
    echo "mediainfo failed to install"
    exit 1
fi


# http://sourceforge.net/projects/libdc1394/files/?source=navbar
# 2019-12-11

cd /usr/local/src/
wget -c http://downloads.sourceforge.net/project/libdc1394/libdc1394-2/2.2.6/libdc1394-2.2.6.tar.gz
tar zxfv libdc1394-2.2.6.tar.gz
cd /usr/local/src/libdc1394-2.2.6
make clean && make distclean
./configure
make
make install

if [ $? -ne 0 ]; then
    echo "libdc1394 failed to install"
    exit 1
fi


cd /usr/local/src/
wget -c http://www.mplayerhq.hu/MPlayer/releases/codecs/all-20071007.tar.bz2
tar -jxvf all-20071007.tar.bz2
cd /usr/local/src/all-20071007
mv /usr/local/lib/codecs /usr/local/lib/codecs-$(date +%m%d%Y%H%N)
mkdir -p /usr/local/lib/codecs
cp -f *.* /usr/local/lib/codecs/
chmod -R 755 /usr/local/lib/codecs/
ls -l /usr/local/lib/codecs/
ln -sf /usr/local/lib/codecs /usr/lib/codecs
ln -sf /usr/local/lib/codecs /usr/local/lib/win32
ln -sf /usr/local/lib/codecs /usr/lib/win32
ldconfig

# http://www.mplayerhq.hu/design7/dload.html

cd /usr/local/src
wget http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.4.tar.xz
tar xvf MPlayer-1.4.tar.xz
cd MPlayer-1.4
echo y | ./configure --prefix=/usr --codecsdir=/usr/local/lib/codecs/ --enable-theora
make && make install

cd /usr/local/src
wget http://www.mplayerhq.hu/MPlayer/releases/mplayer-checkout-snapshot.tar.bz2
tar xvf mplayer-checkout-snapshot.tar.bz2
cd mplayer-checkout-2022-01-12
echo y | ./configure --prefix=/usr --codecsdir=/usr/local/lib/codecs/ --enable-theora
make && make install

if [ $? -ne 0 ]; then
    echo "mplayer failed to install"
    exit 1
fi


# https://www.webmproject.org/code/
# https://github.com/webmproject/libvpx/releases
# cmd = vpxenc

cd /usr/local/src/
wget https://github.com/webmproject/libvpx/archive/v1.6.1.tar.gz -O libvpx.tar.gz
tar xvf libvpx.tar.gz
cd /usr/local/src/libvpx-*
make clean && make distclean
./configure --prefix=/usr --enable-shared
make
make install

if [ $? -ne 0 ]; then
    echo "libvpx failed to install"
    exit 1
fi


# https://github.com/FFmpeg/FFmpeg/releases
# Updated on 2016-10-13
# libavcodec/libfdk-aacenc.c:292:34: error: ‘AACENC_InfoStruct’ has no member named ‘encoderDelay’


pkg-config --exists --print-errors vorbis
export PKG_CONFIG_PATH="/usr/lib/pkgconfig"

cd /usr/local/src/
wget https://ffmpeg.org/releases/ffmpeg-4.3.2.tar.xz
tar xvf ffmpeg-4.3.2.tar.xz 
cd ffmpeg-4.3.2
make clean && make distclean
./configure --prefix=/usr --enable-shared --enable-libxvid --enable-libvorbis --enable-libtheora --enable-libmp3lame --enable-gpl --enable-libfdk-aac --enable-nonfree --enable-libx264 --enable-libfreetype
make && make install && ldconfig

if [ $? -ne 0 ]; then
    echo "gpac failed to install"
    exit 1
fi

cd /usr/local/src/ffmpeg-4.3.2/
make tools/qt-faststart
cp -a tools/qt-faststart /usr/bin/

ldconfig

# if cloudlinux

wget https://raw.githubusercontent.com/serverok/server-setup/master/data/cagefs_git.cfg -O /etc/cagefs/conf.d/git.cfg
wget https://raw.githubusercontent.com/serverok/server-setup/master/data/cagefs_vshare.cfg -O /etc/cagefs/conf.d/vshare.cfg

/usr/sbin/cagefsctl --enable-all

cagefsctl --force-update

