#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export koolddns_`

mkdir -p $KSROOT/init.d
cp -rf /tmp/koolddns/init.d/* $KSROOT/init.d/
cp -rf /tmp/koolddns/scripts/* $KSROOT/scripts/
cp -rf /tmp/koolddns/webs/* $KSROOT/webs/
cp /tmp/koolddns/uninstall.sh $KSROOT/scripts/uninstall_koolddns.sh

chmod +x $KSROOT/scripts/koolddns_*
chmod +x $KSROOT/koolddns/koolddns.sh
chmod +x $KSROOT/koolddns/*

[ -z "$koolddns_dm_api_1" ] && dbus set koolddns_dm_node_max=0
dbus set softcenter_module_koolddns_description=动态域名解析工具
dbus set softcenter_module_koolddns_install=1
dbus set softcenter_module_koolddns_name=koolddns
dbus set softcenter_module_koolddns_title="Koolddns"
dbus set softcenter_module_koolddns_version=0.1

sleep 1
rm -rf /tmp/koolddns >/dev/null 2>&1
