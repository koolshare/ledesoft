#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export bridge`

confs=`dbus list bridge|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/bridge*
rm -rf $KSROOT/webs/Module_bridge.asp
rm -rf $KSROOT/webs/res/icon-bridge.png
rm -rf $KSROOT/webs/res/icon-bridge-bg.png

dbus remove softcenter_module_bridge_home_url
dbus remove softcenter_module_bridge_install
dbus remove softcenter_module_bridge_md5
dbus remove softcenter_module_bridge_version
dbus remove softcenter_module_bridge_name
dbus remove softcenter_module_bridge_description

rm -rf $KSROOT/scripts/uninstall_bridge.sh
