#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export routetable`

confs=`dbus list routetable|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf /etc/hotplug.d/iface/97-routetable
rm -rf $KSROOT/scripts/routetable*
rm -rf $KSROOT/routetable
rm -rf $KSROOT/webs/Module_routetable.asp
rm -rf $KSROOT/webs/res/icon-routetable.png
rm -rf $KSROOT/webs/res/icon-routetable-bg.png
rm -rf /etc/init.d/S80routetable.sh >/dev/null 2>&1

dbus remove softcenter_module_routetable_home_url
dbus remove softcenter_module_routetable_install
dbus remove softcenter_module_routetable_md5
dbus remove softcenter_module_routetable_version
dbus remove softcenter_module_routetable_name
dbus remove softcenter_module_routetable_description
rm -rf $KSROOT/scripts/uninstall_routetable.sh
