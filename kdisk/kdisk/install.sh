#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export kdisk_`

cd /tmp
cp -rf /tmp/kdisk/scripts/* $KSROOT/scripts/
cp -rf /tmp/kdisk/webs/* $KSROOT/webs/
cp /tmp/kdisk/uninstall.sh $KSROOT/scripts/uninstall_kdisk.sh

chmod +x $KSROOT/scripts/kdisk_*

dbus set softcenter_module_kdisk_description=安装盘剩余空间挂载
dbus set softcenter_module_kdisk_install=1
dbus set softcenter_module_kdisk_name=kdisk
dbus set softcenter_module_kdisk_title=硬盘助手
dbus set softcenter_module_kdisk_version=0.1

sleep 1
rm -rf /tmp/kdisk >/dev/null 2>&1
