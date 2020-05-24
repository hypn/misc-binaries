#!/bin/bash

mkdir -p /tmp/netcat
cd /tmp/netcat

wget https://dl.packetstormsecurity.net/UNIX/netcat/nc110.tgz --no-check-certificate
tar -zxvf nc110.tgz

sed -i 's/res_init/ \/\/res_init/' netcat.c
sed -i 's/FD_SETSIZE 16/FD_SETSIZE 1024/' netcat.c
gcc netcat.c -o /tmp/nc-dynamic -DGAPING_SECURITY_HOLE
gcc netcat.c -o /tmp/nc-static -DGAPING_SECURITY_HOLE --static