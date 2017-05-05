#!/bin/sh
export KSROOT=/jffs/koolshare

rm -rf $KSROOT/scripts/xiaomi_*
rm -rf $KSROOT/init.d/S100Xiaomi.sh
rm -rf $KSROOT/res/icon-xiaomi*
rm -rf $KSROOT/web/Module_xiaomi.asp

cp -rf /tmp/xiaomi/res/* $KSROOT/res/
cp -rf /tmp/xiaomi/scripts/* $KSROOT/scripts/
cp -rf /tmp/xiaomi/webs/* $KSROOT/webs/

chmod a+x $KSROOT/scripts/xiaomi_*

# add icon into softerware center
dbus set softcenter_module_xiaomi_install=1
dbus set softcenter_module_xiaomi_version=1.0
dbus set softcenter_module_xiaomi_description="小米R1D风扇控制插件"
dbus set softcenter_module_xiaomi_title="xiaomi fan control"
dbus set softcenter_module_xiaomi_nae="xiaomi"
rm -rf /tmp/xiaomi*

