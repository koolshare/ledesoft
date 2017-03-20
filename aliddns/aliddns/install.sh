#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

rm -rf $KSROOT/scripts/aliddns_*
rm -rf $KSROOT/init.d/S98Aliddns.sh
rm -rf $KSROOT/res/icon-aliddns*
rm -rf $KSROOT/web/Module_aliddns.asp

cp -r /tmp/aliddns/* $KSROOT/
chmod a+x $KSROOT/scripts/aliddns_*

# add icon into softerware center
dbus set softcenter_module_aliddns_install=1
dbus set softcenter_module_aliddns_version=0.4
dbus set softcenter_module_aliddns_description="阿里云解析自动更新IP"
rm -rf $KSROOT/install.sh
