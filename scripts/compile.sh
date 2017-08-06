#!/bin/bash
# cd /tmp && wget http://10.0.2.2:8080/compile.sh && chmod +x compile.sh && ./compile.sh

echo "deb http://archive.debian.org/debian squeeze main" > /etc/apt/sources.list
echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf
apt-get update && apt-get install debian-keyring && apt-get install -y build-essential

# netcat
cd /tmp
wget http://10.0.2.2:8080/nc110.tgz
mkdir nc && cd nc
tar -zxvf ../nc110.tgz
sed -i 's/res_init/ \/\/res_init/' netcat.c
sed -i 's/FD_SETSIZE 16/FD_SETSIZE 1024/' netcat.c
gcc netcat.c -o /tmp/nc-dynamic -DGAPING_SECURITY_HOLE
gcc netcat.c -o /tmp/nc-static -DGAPING_SECURITY_HOLE --static

# busybox
cd /tmp
apt-get install linux-headers-$(uname -r)
wget http://10.0.2.2:8080/busybox-1.2.2.tar.bz2
tar -xvjf busybox-1.2.2.tar.bz2
cd busybox-1.2.2
	# fix busybox compilation on squeeze
	wget http://10.0.2.2:8080/.config
	cd include
	wget http://10.0.2.2:8080/bb_config.h 
	cd ..
	sed -i 's/#include <asm\/page.h>/\/\/ #include <asm\/page.h>/' util-linux/mkswap.c
make
mv busybox /tmp/busybox-dynamic
make clean && make LDFLAGS='-static'
mv busybox /tmp/busybox-static

# socat
cd /tmp
wget http://10.0.2.2:8080/socat-1.7.3.2.tar.gz
tar -zxvf socat-1.7.3.2.tar.gz
cd socat-1.7.3.2
./configure
make
cp socat /tmp/socat-dynamic
make clean && ./configure LDFLAGS="-static"
make
cp socat /tmp/socat-static
