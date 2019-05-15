#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export unifi_`

mkdir -p $KSROOT/init.d
cd /tmp
cp -rf /tmp/unifi/scripts/* $KSROOT/scripts/
cp -rf /tmp/unifi/init.d/* $KSROOT/init.d/
cp -rf /tmp/unifi/webs/* $KSROOT/webs/
cp /tmp/unifi/uninstall.sh $KSROOT/scripts/uninstall_unifi.sh

chmod +x $KSROOT/scripts/unifi_*
chmod +x $KSROOT/init.d/S99unifi.sh

dbus set softcenter_module_unifi_description=Unifi控制器和Debian系统
dbus set softcenter_module_unifi_install=1
dbus set softcenter_module_unifi_name=unifi
dbus set softcenter_module_unifi_title="Unifi Controller"
dbus set softcenter_module_unifi_version=0.1

sleep 1
rm -rf /tmp/unifi* >/dev/null 2>&1
