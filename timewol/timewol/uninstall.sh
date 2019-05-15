#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export timewol`

confs=`dbus list timewol|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/timewol_*
rm -rf $KSROOT/webs/Module_timewol.asp
rm -rf $KSROOT/webs/res/icon-timewol.png
rm -rf $KSROOT/webs/res/icon-timewol-bg.png

dbus remove softcenter_module_timewol_home_url
dbus remove softcenter_module_timewol_install
dbus remove softcenter_module_timewol_md5
dbus remove softcenter_module_timewol_version
dbus remove softcenter_module_timewol_name
dbus remove softcenter_module_timewol_description
rm -rf $KSROOT/scripts/uninstall_timewol.sh
