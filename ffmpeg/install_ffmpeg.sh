#!/bin/bash

CFLAGS="-fPIC";export CFLAGS

echo "/usr/lib64/" > /etc/ld.so.conf.d/hostonnet_ffmpeg.conf
echo "/usr/local/lib" >> /etc/ld.so.conf.d/hostonnet_ffmpeg.conf
echo "/usr/lib" >> /etc/ld.so.conf.d/hostonnet_ffmpeg.conf
cat /etc/ld.so.conf.d/hostonnet_ffmpeg.conf
ldconfig

yum -y install lynx jwhois
yum -y install nmap
yum -y install ncurses-devel
yum -y install automake
yum -y install autoconf
yum -y install gcc
yum -y install gmake
yum -y install patch
yum -y install make
yum -y install libcpp
yum -y install libgcc
yum -y install libstdc++
yum -y install gcc4
yum -y install gcc4-c++
yum -y install gcc4-gfortran
yum -y install dos2unix
yum -y install libtool
yum -y install gcc-c++
yum -y install gcc-c++ compat-gcc-32 compat-gcc-32-c++
yum -y install unzip bzip2

mkdir -p /usr/local/src/tmp
chmod 777 /usr/local/src/tmp
export TMPDIR=/usr/local/src/tmp

if [ -f /usr/local/cpanel/version ];
then
    /scripts/installruby
else
    yum -y install ruby
    cd /usr/local/src
    wget -c http://www.ijg.org/files/jpegsrc.v9a.tar.gz
    tar xvf jpegsrc.v9a.tar.gz
    cd /usr/local/src/jpeg-9
    ./configure  --prefix=/usr
    make
    make install
fi

# https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

cd /usr/local/src/
wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master
tar xzvf fdk-aac.tar.gz
cd mstorsjo-fdk-aac*
autoreconf -fiv
./configure --prefix=/usr
make
make install
make distclean
ldconfig

# http://sourceforge.net/projects/faac/files/

cd /usr/local/src/
wget -c http://downloads.sourceforge.net/project/faac/faac-src/faac-1.28/faac-1.28.tar.gz
tar -zxvf faac-1.28.tar.gz
cd /usr/local/src/faac*
sed -i '/char \*strcasestr(const char \*haystack, const char \*needle);/d' ./common/mp4v2/mpeg4ip.h
./bootstrap
./configure --prefix=/usr
make && make install
ldconfig

cd /usr/local/src/
wget -c http://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.7/faad2-2.7.tar.gz
tar -zxvf faad2-2.7.tar.gz
cd /usr/local/src/faad2*
autoreconf -vif
./configure --prefix=/usr
make && make install

# https://xiph.org/downloads/

cd /usr/local/src/
wget -c http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
tar zxvf libogg-1.3.2.tar.gz
cd /usr/local/src/libogg-1.3.2
./configure && make && make install
ldconfig

# http://www.xiph.org/downloads/

cd /usr/local/src/
wget -c http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.gz
tar zxvf libvorbis-1.3.5.tar.gz
cd /usr/local/src/libvorbis-1.3.5
./configure && make && make install

# http://lame.sourceforge.net/download.php

cd /usr/local/src/
wget -c http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xf lame-3.99.5.tar.gz
cd /usr/local/src/lame-3.99.5
./configure --enable-shared --prefix=/usr
make && make install

# http://www.xvid.org/Downloads.43.0.html

cd /usr/local/src/
wget -c http://downloads.xvid.org/downloads/xvidcore-1.3.4.tar.gz
tar xvf xvidcore-1.3.4.tar.gz
cd /usr/local/src/xvidcore/build/generic/
./configure --prefix=/usr && make && make install

# http://rubyforge.org/projects/flvtool2/
# http://www.inlet-media.de/2009/11/flvtool2.html

cd /usr/local/src
wget https://github.com/unnu/flvtool2/archive/master.zip -O flvtool2.zip
unzip flvtool2.zip
cd /usr/local/src/flvtool2-master/
ruby setup.rb config --prefix=/usr
ruby setup.rb setup
ruby setup.rb install

# http://yamdi.sourceforge.net/

cd /usr/local/src
wget -c http://downloads.sourceforge.net/project/yamdi/yamdi/1.9/yamdi-1.9.tar.gz
tar -zxvf yamdi-1.9.tar.gz
cd /usr/local/src/yamdi-1.9
gcc yamdi.c -o yamdi -O2 -Wall
mv yamdi /usr/bin/

#cd /usr/local/src
#git clone https://github.com/ioppermann/yamdi.git

cd /usr/local/src
wget -c http://liba52.sourceforge.net/files/a52dec-0.7.4.tar.gz
tar xvf a52dec-0.7.4.tar.gz
cd /usr/local/src/a52dec*
./configure
make && make install

# http://www.penguin.cz/~utx/amr#download

cd /usr/local/src/
wget -c http://www.penguin.cz/~utx/ftp/amr/amrnb-11.0.0.0.tar.bz2
tar jxvf amrnb-11.0.0.0.tar.bz2
cd /usr/local/src/amrnb-11.0.0.0
./configure
make && make install

cd /usr/local/src/
wget --no-check-certificate -c http://www.penguin.cz/~utx/ftp/amr/amrwb-11.0.0.0.tar.bz2
tar jxvf amrwb-11.0.0.0.tar.bz2
cd /usr/local/src/amrwb-11.0.0.0
./configure
make && make install

# http://yasm.tortall.net/Download.html
# 23-Oct-2015 09:01 AM

cd /usr/local/src
git clone git://github.com/yasm/yasm.git
cd /usr/local/src/yasm
./configure
make && make install

# http://www.penguin.cz/~utx/amr#download

cd /usr/local/src/
wget -c http://www.penguin.cz/~utx/ftp/amr/amrnb-11.0.0.0.tar.bz2
tar jxvf amrnb-11.0.0.0.tar.bz2
cd /usr/local/src/amrnb-11.0.0.0
./configure
make && make install

cd /usr/local/src/
wget --no-check-certificate -c http://www.penguin.cz/~utx/ftp/amr/amrwb-11.0.0.0.tar.bz2
tar jxvf amrwb-11.0.0.0.tar.bz2
cd /usr/local/src/amrwb-11.0.0.0
./configure
make && make install

# http://yasm.tortall.net/Download.html
# 23-Oct-2015 09:01 AM

cd /usr/local/src
git clone git://github.com/yasm/yasm.git
cd /usr/local/src/yasm
./configure
make && make install

# http://www.videolan.org/developers/x264.html

cd /usr/local/src
git clone --depth 1 git://git.videolan.org/x264.git
cd /usr/local/src/x264/
git pull
make clean && make distclean
./configure --prefix=/usr --enable-shared
make && make install

cd /usr/local/src
wget -c http://ftp6.nero.com/tools/NeroDigitalAudio.zip
unzip NeroDigitalAudio.zip -d nero
cd nero/linux
install -D -m755 neroAacEnc /usr/local/bin

# https://gpac.wp.mines-telecom.fr/
# 23-Oct-2015 09:12 AM

cd /usr/local/src
git clone https://github.com/gpac/gpac.git
cd /usr/local/src/gpac
sh ./configure
make
make install

# http://sourceforge.net/projects/libdc1394/files/?source=navbar
# updated on 12-May-2015 09:32 AM

cd /usr/local/src
wget -c http://liquidtelecom.dl.sourceforge.net/project/libdc1394/libdc1394-2/2.2.3/libdc1394-2.2.3.tar.gz
tar zxfv libdc1394-2.2.3.tar.gz
cd /usr/local/src/libdc1394-2.2.3
make clean && make distclean
./configure
make
make install

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
