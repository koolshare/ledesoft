#!/bin/sh
cd /tmp
/usr/bin/wget https://ledesoft.ngrok.wang/softcenter/softcenter.tar.gz
tar -zxvf /tmp/softcenter.tar.gz
sh /tmp/softcenter/install.sh
