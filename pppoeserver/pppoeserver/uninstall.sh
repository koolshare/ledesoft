#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export pppoeserver`

confs=`dbus list pppoeserver|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/pppoeserver*
rm -rf $KSROOT/webs/Module_pppoeserver.asp
rm -rf $KSROOT/webs/res/icon-pppoeserver.png
rm -rf $KSROOT/webs/res/icon-pppoeserver-bg.png
rm -rf $KSROOT/init.d/S99pppoeserver.sh

dbus remove softcenter_module_pppoeserver_home_url
dbus remove softcenter_module_pppoeserver_install
dbus remove softcenter_module_pppoeserver_md5
dbus remove softcenter_module_pppoeserver_version
dbus remove softcenter_module_pppoeserver_name
dbus remove softcenter_module_pppoeserver_description
rm -rf $KSROOT/scripts/uninstall_pppoeserver.sh
