#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export bbr`

confs=`dbus list bbr|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/bbr*
rm -rf $KSROOT/webs/Module_bbr.asp
rm -rf $KSROOT/webs/res/icon-bbr.png
rm -rf $KSROOT/webs/res/icon-bbr-bg.png

dbus remove softcenter_module_bbr_home_url
dbus remove softcenter_module_bbr_install
dbus remove softcenter_module_bbr_md5
dbus remove softcenter_module_bbr_version
dbus remove softcenter_module_bbr_name
dbus remove softcenter_module_bbr_description

rm -rf $KSROOT/scripts/uninstall_bbr.sh
