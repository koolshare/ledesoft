#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export webrecord_`

cp -rf /tmp/webrecord/init.d/* $KSROOT/init.d/
cp -rf /tmp/webrecord/scripts/* $KSROOT/scripts/
cp -rf /tmp/webrecord/webs/* $KSROOT/webs/
cp /tmp/webrecord/uninstall.sh $KSROOT/scripts/uninstall_webrecord.sh

chmod +x $KSROOT/scripts/webrecord_*

dbus set softcenter_module_webrecord_description=查看网址和搜索记录
dbus set softcenter_module_webrecord_install=1
dbus set softcenter_module_webrecord_name=webrecord
dbus set softcenter_module_webrecord_title="上网记录"
dbus set softcenter_module_webrecord_version=0.1

sleep 1
rm -rf /tmp/webrecord >/dev/null 2>&1
