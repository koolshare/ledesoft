#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

cp -r /tmp/xunlei/* $KSROOT/
chmod a+x $KSROOT/scripts/xunlei_*.sh
chmod a+x $KSROOT/xunlei/*

# add icon into softerware center
dbus set softcenter_module_xunlei_install=1
dbus set softcenter_module_xunlei_version=0.2
dbus set softcenter_module_xunlei_description="迅雷远程下载服务"
rm -rf /jffs/koolshare/install.sh