#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export entware_`

mkdir -p $KSROOT/init.d
cp -rf /tmp/entware/bin/* $KSROOT/bin/
cp -rf /tmp/entware/scripts/* $KSROOT/scripts/
cp -rf /tmp/entware/init.d/* $KSROOT/init.d/
cp -rf /tmp/entware/webs/* $KSROOT/webs/
cp /tmp/entware/uninstall.sh $KSROOT/scripts/uninstall_entware.sh

chmod +x $KSROOT/scripts/entware_*
chmod +x $KSROOT/init.d/S99entware.sh

dbus set softcenter_module_entware_description="Entware环境和扩展"
dbus set softcenter_module_entware_install=1
dbus set softcenter_module_entware_name=entware
dbus set softcenter_module_entware_title="Entware"
dbus set softcenter_module_entware_version=0.1

sleep 1
rm -rf /tmp/entware* >/dev/null 2>&1
