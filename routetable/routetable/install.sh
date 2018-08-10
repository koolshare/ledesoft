#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

cp -rf /tmp/routetable/scripts/* $KSROOT/scripts/
cp -rf /tmp/routetable/webs/* $KSROOT/webs/
cp -rf /tmp/routetable/init.d/* $KSROOT/init.d/
cp /tmp/routetable/uninstall.sh $KSROOT/scripts/uninstall_routetable.sh

chmod +x $KSROOT/scripts/routetable_*

dbus set softcenter_module_routetable_description=路由流量指明灯
dbus set softcenter_module_routetable_install=1
dbus set softcenter_module_routetable_name=routetable
dbus set softcenter_module_routetable_title="路由表设置"
dbus set softcenter_module_routetable_version=0.1

sleep 1
rm -rf /tmp/routetable >/dev/null 2>&1
