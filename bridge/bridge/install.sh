#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export bridge_`

mkdir -p $KSROOT/init.d
cd /tmp
cp -rf /tmp/bridge/scripts/* $KSROOT/scripts/
cp -rf /tmp/bridge/webs/* $KSROOT/webs/
cp /tmp/bridge/uninstall.sh $KSROOT/scripts/uninstall_bridge.sh

chmod +x $KSROOT/scripts/bridge_*

dbus set softcenter_module_bridge_description=无感知的透明防火墙
dbus set softcenter_module_bridge_install=1
dbus set softcenter_module_bridge_name=bridge
dbus set softcenter_module_bridge_title=透明网桥
dbus set softcenter_module_bridge_version=0.1

sleep 1
rm -rf /tmp/bridge* >/dev/null 2>&1
