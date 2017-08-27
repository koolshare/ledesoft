#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

cp -r /tmp/dnspod/* $KSROOT/
chmod a+x $KSROOT/scripts/dnspod_*
chmod a+x $KSROOT/scripts/uigetwan.sh

cp /tmp/dnspod/uninstall.sh $KSROOT/scripts/uninstall_dnspod.sh

# add icon into softerware center
dbus set softcenter_module_dnspod_install=1
dbus set softcenter_module_dnspod_version=0.1
dbus set softcenter_module_dnspod_description="DNSPOD动态域名解析"
dbus set softcenter_module_ddnsto_name=dnspod
dbus set softcenter_module_ddnsto_title=dnspod

rm -rf $KSROOT/install.sh
rm -rf /tmp/dnspod* >/dev/null 2>&1
