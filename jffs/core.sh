#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

#启动环境服务
chmod 755 $KSROOT/bin/*
chmod 755 $KSROOT/scripts/*

SKIPD_PID=$(pidof skipd)
if [ "$SKIPD_PID" == "" ]; then
rm -f /tmp/skpid.pid
$KSROOT/bin/skipd &
fi

#80
lanport=$(nvram get http_lanport) 
if [ "$lanport" != "9527" ]; then
nvram set http_lanport1=$lanport
nvram set http_lanport=9527
nvram commit
service httpd restart
fi

HTTPDB_PID=$(pidof httpdb)
if [ "$HTTPDB_PID" == "" ]; then
rm -f /tmp/httpdb.pid
lanport1=$(nvram get http_lanport1)
$KSROOT/bin/httpdb -p $lanport1 -r $LANIP:9527 >/tmp/httpdb.pid 2>&1 &
fi

#初始化软件中心
if [ `dbus get softcenter_version` == "" ]; then
dbus set softcenter_version=0.0.0
fi

