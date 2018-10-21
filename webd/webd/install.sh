#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export webd_`

mkdir -p $KSROOT/init.d

cp -rf /tmp/webd/bin/* $KSROOT/bin/
cp -rf /tmp/webd/init.d/* $KSROOT/init.d/
cp -rf /tmp/webd/scripts/* $KSROOT/scripts/
cp -rf /tmp/webd/webs/* $KSROOT/webs/
cp -rf /tmp/webd/uninstall.sh $KSROOT/scripts/uninstall_webd.sh
chmod a+x $KSROOT/scripts/webd_*
chmod a+x $KSROOT/init.d/S99webd.sh
chmod a+x $KSROOT/bin/webd

# add icon into softerware center
dbus set softcenter_module_webd_install=1
dbus set softcenter_module_webd_name=webd
dbus set softcenter_module_webd_title="我的网盘"
dbus set softcenter_module_webd_description="小巧便携的网盘"
dbus set softcenter_module_webd_version=1.0

rm -rf /tmp/webd
