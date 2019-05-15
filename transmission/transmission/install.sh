#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export transmission_`

cd /tmp
cp -rf /tmp/transmission/scripts/* $KSROOT/scripts/
cp -rf /tmp/transmission/webs/* $KSROOT/webs/
cp /tmp/transmission/uninstall.sh $KSROOT/scripts/uninstall_transmission.sh

chmod +x $KSROOT/scripts/transmission_*

dbus set softcenter_module_transmission_description="高效的BT、PT下载工具"
dbus set softcenter_module_transmission_install=1
dbus set softcenter_module_transmission_name=transmission
dbus set softcenter_module_transmission_title=Transmission
dbus set softcenter_module_transmission_version=0.1

sleep 1
rm -rf /tmp/transmission* >/dev/null 2>&1
