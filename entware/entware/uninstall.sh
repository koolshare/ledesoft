#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export entware`

confs=`dbus list entware|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/bin/entware
rm -rf $KSROOT/bin/tz
rm -rf $KSROOT/scripts/entware*
rm -rf $KSROOT/init.d/S99entware.sh
rm -rf $KSROOT/webs/Module_entware.asp
rm -rf $KSROOT/webs/res/icon-entware.png
rm -rf $KSROOT/webs/res/icon-entware-bg.png
rm -rf $KSROOT/scripts/uninstall_entware.sh
rm -rf /etc/rc.d/S99entware.sh

dbus remove softcenter_module_entware_home_url
dbus remove softcenter_module_entware_install
dbus remove softcenter_module_entware_md5
dbus remove softcenter_module_entware_version
dbus remove softcenter_module_entware_name
dbus remove softcenter_module_entware_description
