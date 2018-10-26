#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export baidupcs`

mkdir -p $KSROOT/init.d
mkdir -p /tmp/upload

cp -rf /tmp/baidupcs/bin/* $KSROOT/bin/
cp -rf /tmp/baidupcs/scripts/* $KSROOT/scripts/
cp -rf /tmp/baidupcs/init.d/* $KSROOT/init.d/
cp -rf /tmp/baidupcs/webs/* $KSROOT/webs/
cp /tmp/baidupcs/uninstall.sh $KSROOT/scripts/uninstall_baidupcs.sh

chmod +x $KSROOT/bin/baidupcs
chmod +x $KSROOT/scripts/baidupcs_*
chmod +x $KSROOT/init.d/S99baidupcs.sh

dbus set softcenter_module_baidupcs_description=百度网盘同步管理工具
dbus set softcenter_module_baidupcs_install=1
dbus set softcenter_module_baidupcs_name=baidupcs
dbus set softcenter_module_baidupcs_title=百度网盘
dbus set softcenter_module_baidupcs_version=0.1

rm -rf /tmp/baidupcs >/dev/null 2>&1
