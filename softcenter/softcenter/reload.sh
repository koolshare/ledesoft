#!/bin/sh

mkdir -p /koolshare
export KSROOT=/koolshare

# kill softcenter first
/etc/init.d/softcenter stop

# now make some folders
mkdir -p $KSROOT
mkdir -p $KSROOT/webs/
mkdir -p $KSROOT/init.d/
mkdir -p $KSROOT/webs/res/
mkdir -p $KSROOT/bin/
mkdir -p /tmp/upload

# now copy files
cp -rf /tmp/softcenter/webs/* $KSROOT/webs/
cp -rf /tmp/softcenter/bin/* $KSROOT/bin/
cp -rf /tmp/softcenter/scripts $KSROOT/
cp -rf /tmp/softcenter/init.d/* $KSROOT/init.d/
chmod 755 $KSROOT/bin/*
chmod 755 $KSROOT/scripts/*
chmod 755 $KSROOT/init.d/*

# make dectec link
sleep 1
ln -sf /koolshare/init.d/S71softok.sh /etc/rc.d/S71softok.sh

# remove install package
rm -rf /tmp/softcenter*

# remove luci cache
rm -rf /tmp/luci-*
[ -d "/koolshare/init.d/init.d"  ] && rm -rf /koolshare/init.d/init.d
# bring up softcenter
/etc/init.d/softcenter start

