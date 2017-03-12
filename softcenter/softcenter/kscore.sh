#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

mkdir -p /tmp/upload
mkdir -p $KSROOT/perp/.control
mkdir -p $KSROOT/perp/.boot
mkdir -p $KSROOT/init.d
chmod 755 $KSROOT/bin/*
chmod 755 $KSROOT/scripts/*
chmod 755 $KSROOT/perp/*
chmod 755 $KSROOT/perp/httpdb/*
chmod 755 $KSROOT/perp/skipd/*
chmod 755 $KSROOT/perp/.boot/*
chmod 755 $KSROOT/perp/.control/*

if [ ! -L $KSROOT/webs/res ]; then
	cd $KSROOT/webs && rm -rf $KSROOT/webs/res && ln -sf $KSROOT/res res && cd -
fi

$KSROOT/perp/perp.sh start
SKIPD_PID=$(pidof skipd)
if [ "$SKIPD_PID" == "" ]; then
perp-restart skipd
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
perp-restart httpdb
fi

SOFTVER=`dbus get softcenter_version`
if [ "$SOFTVER" == "" ]; then
dbus set softcenter_version=0.0.0
fi

$KSROOT/bin/startwan.sh
