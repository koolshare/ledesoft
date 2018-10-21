#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export v2ray_`

mkdir -p $KSROOT/init.d
mkdir -p $KSROOT/v2ray
cp -rf /tmp/v2ray/bin/* $KSROOT/bin/
cp -rf /tmp/v2ray/init.d/* $KSROOT/init.d/
cp -rf /tmp/v2ray/v2ray/* $KSROOT/v2ray/
cp -rf /tmp/v2ray/scripts/* $KSROOT/scripts/
cp -rf /tmp/v2ray/webs/* $KSROOT/webs/
cp /tmp/v2ray/uninstall.sh $KSROOT/scripts/uninstall_v2ray.sh

chmod +x $KSROOT/scripts/v2ray_*
chmod +x $KSROOT/scripts/uninstall_v2ray.sh
chmod +x $KSROOT/bin/v2ray
chmod +x $KSROOT/bin/v2ctl

dbus set softcenter_module_v2ray_description=模块化的代理软件包
dbus set softcenter_module_v2ray_install=1
dbus set softcenter_module_v2ray_name=v2ray
dbus set softcenter_module_v2ray_title="V2Ray"
dbus set softcenter_module_v2ray_version=0.1

sleep 1
rm -rf $KSROOT/v2ray/gfw.txt
rm -rf $KSROOT/init.d/S98v2ray.sh
rm -rf /tmp/v2ray >/dev/null 2>&1
