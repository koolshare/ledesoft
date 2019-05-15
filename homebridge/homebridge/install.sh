#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export homebridge_`

mkdir -p $KSROOT/init.d
cd /tmp
cp -rf /tmp/homebridge/scripts/* $KSROOT/scripts/
cp -rf /tmp/homebridge/init.d/* $KSROOT/init.d/
cp -rf /tmp/homebridge/webs/* $KSROOT/webs/
cp /tmp/homebridge/uninstall.sh $KSROOT/scripts/uninstall_homebridge.sh

chmod +x $KSROOT/scripts/homebridge_*
chmod +x $KSROOT/init.d/S98homebridge.sh

opkg remove node-mdns node-homebridge node-npm node 

rm -rf $KSROOT/homebridge/accessories
rm -rf $KSROOT/homebridge/persist
rm -rf /usr/lib/node_modules
rm -rf /usr/lib/node

dbus set softcenter_module_homebridge_description=智能家庭网关
dbus set softcenter_module_homebridge_install=1
dbus set softcenter_module_homebridge_name=homebridge
dbus set softcenter_module_homebridge_title=Homebridge
dbus set softcenter_module_homebridge_version=0.1

sleep 1
rm -rf /tmp/homebridge* >/dev/null 2>&1
