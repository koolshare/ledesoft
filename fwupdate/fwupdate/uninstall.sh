#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

rm -rf /lib/upgrade/keep.d/fwupdate
rm -rf $KSROOT/scripts/fwupdate_config.sh >/dev/null 2>&1
rm -rf $KSROOT/scripts/fwupdate_status.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_fwupdate.asp >/dev/null 2>&1
rm -rf $KSROOT/webs/res/icon-fwupdate* >/dev/null 2>&1

confs=`dbus list fwupdate|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

dbus remove softcenter_module_fwupdate_home_url
dbus remove softcenter_module_fwupdate_install
dbus remove softcenter_module_fwupdate_md5
dbus remove softcenter_module_fwupdate_version
dbus remove softcenter_module_fwupdate_name
dbus remove softcenter_module_fwupdate_description
