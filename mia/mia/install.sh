#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export mia_`

cp -rf /tmp/mia/init.d/* $KSROOT/init.d/
cp -rf /tmp/mia/scripts/* $KSROOT/scripts/
cp -rf /tmp/mia/webs/* $KSROOT/webs/
cp /tmp/mia/uninstall.sh $KSROOT/scripts/uninstall_mia.sh

chmod +x $KSROOT/scripts/mia_*

dbus set softcenter_module_mia_description=限时网址及协议过滤
dbus set softcenter_module_mia_install=1
dbus set softcenter_module_mia_name=mia
dbus set softcenter_module_mia_title="家长控制"
dbus set softcenter_module_mia_version=0.1

sleep 1
rm -rf /tmp/mia >/dev/null 2>&1
