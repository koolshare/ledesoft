#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export sqos`

confs=`dbus list sqos|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/sqos*
rm -rf $KSROOT/sqos
rm -rf $KSROOT/webs/Module_sqos.asp
rm -rf $KSROOT/webs/res/icon-sqos.png
rm -rf $KSROOT/webs/res/icon-sqos-bg.png
rm -rf $KSROOT/init.d/S98sqos.sh
rm -rf /etc/hotplug.d/iface/98-sqos
rm -rf /etc/rc.d/S98sqos.sh

dbus remove softcenter_module_sqos_home_url
dbus remove softcenter_module_sqos_install
dbus remove softcenter_module_sqos_md5
dbus remove softcenter_module_sqos_version
dbus remove softcenter_module_sqos_name
dbus remove softcenter_module_sqos_description
rm -rf $KSROOT/scripts/uninstall_sqos.sh
