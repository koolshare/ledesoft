#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export virtual`

confs=`dbus list virtual|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/virtual*
rm -rf $KSROOT/init.d/S90virtual.sh
rm -rf /etc/rc.d/S90virtual.sh
rm -rf $KSROOT/webs/Module_virtual.asp
rm -rf $KSROOT/webs/res/icon-virtual.png
rm -rf $KSROOT/webs/res/icon-virtual-bg.png

dbus remove softcenter_module_virtual_home_url
dbus remove softcenter_module_virtual_install
dbus remove softcenter_module_virtual_md5
dbus remove softcenter_module_virtual_version
dbus remove softcenter_module_virtual_name
dbus remove softcenter_module_virtual_description

rm -rf $KSROOT/scripts/uninstall_virtual.sh
