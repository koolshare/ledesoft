#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export homeassistant_`

mkdir -p $KSROOT/init.d
cd /tmp
cp -rf /tmp/homeassistant/scripts/* $KSROOT/scripts/
cp -rf /tmp/homeassistant/init.d/* $KSROOT/init.d/
cp -rf /tmp/homeassistant/webs/* $KSROOT/webs/
cp /tmp/homeassistant/uninstall.sh $KSROOT/scripts/uninstall_homeassistant.sh

chmod +x $KSROOT/scripts/homeassistant_*
chmod +x $KSROOT/init.d/S98homeassistant.sh

opkg remove node-mdns node-homeassistant node-npm node 

rm -rf $KSROOT/homeassistant/accessories
rm -rf $KSROOT/homeassistant/persist
rm -rf /usr/lib/node_modules
rm -rf /usr/lib/node

dbus set softcenter_module_homeassistant_description=智能家庭网关
dbus set softcenter_module_homeassistant_install=1
dbus set softcenter_module_homeassistant_name=homeassistant
dbus set softcenter_module_homeassistant_title="Home Assistant"
dbus set softcenter_module_homeassistant_version=0.1

sleep 1
rm -rf /tmp/homeassistant* >/dev/null 2>&1
