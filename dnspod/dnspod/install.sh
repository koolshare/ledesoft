#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

cp -r /tmp/dnspod/* $KSROOT/
chmod a+x $KSROOT/scripts/dnspod_*

# add icon into softerware center
dbus set softcenter_module_dnspod_install=1
dbus set softcenter_module_dnspod_version=0.3
dbus set softcenter_module_dnspod_description="DNSPOD动态域名解析"
rm -rf $KSROOT/install.sh