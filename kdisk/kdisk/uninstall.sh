#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export kdisk`

confs=`dbus list kdisk|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/kdisk*
rm -rf $KSROOT/webs/Module_kdisk.asp
rm -rf $KSROOT/webs/res/icon-kdisk.png
rm -rf $KSROOT/webs/res/icon-kdisk-bg.png

dbus remove softcenter_module_kdisk_home_url
dbus remove softcenter_module_kdisk_install
dbus remove softcenter_module_kdisk_md5
dbus remove softcenter_module_kdisk_version
dbus remove softcenter_module_kdisk_name
dbus remove softcenter_module_kdisk_description

rm -rf $KSROOT/scripts/uninstall_kdisk.sh
