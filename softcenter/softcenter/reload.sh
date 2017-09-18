#!/bin/sh

mkdir -p /koolshare
export KSROOT=/koolshare

# kill softcenter first
/etc/init.d/softcenter stop

sleep 1

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
chmod 755 $KSROOT/bin/*
chmod 755 $KSROOT/scripts/*

# remove install package
rm -rf /tmp/softcenter*

# remove luci cache
rm -rf /tmp/luci-*

# bring up softcenter
/etc/init.d/softcenter start

