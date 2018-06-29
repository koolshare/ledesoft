#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export ssrserver`

confs=`dbus list ssrserver|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/ssrserver*
rm -rf $KSROOT/init.d/S99ssrserver.sh
rm -rf $KSROOT/webs/Module_ssrserver.asp
rm -rf $KSROOT/webs/res/icon-ssrserver.png
rm -rf $KSROOT/webs/res/icon-ssrserver-bg.png
rm -rf /etc/rc.d/S99ssrserver.sh

dbus remove softcenter_module_ssrserver_home_url
dbus remove softcenter_module_ssrserver_install
dbus remove softcenter_module_ssrserver_md5
dbus remove softcenter_module_ssrserver_version
dbus remove softcenter_module_ssrserver_name
dbus remove softcenter_module_ssrserver_description

rm -rf $KSROOT/scripts/uninstall_ssrserver.sh
