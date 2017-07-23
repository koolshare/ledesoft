#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export ddnsto`

confs=`dbus list ddnsto|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/bin/ddnsto
rm -rf $KSROOT/scripts/ddnsto*
rm -rf $KSROOT/init.d/S88ddnsto.sh
rm -rf /etc/rc.d/S88ddnsto.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_ddnsto.asp
rm -rf $KSROOT/webs/res/icon-ddnsto.png
rm -rf $KSROOT/webs/res/icon-ddnsto-bg.png

dbus remove softcenter_module_ddnsto_home_url
dbus remove softcenter_module_ddnsto_install
dbus remove softcenter_module_ddnsto_md5
dbus remove softcenter_module_ddnsto_version
dbus remove softcenter_module_ddnsto_name
dbus remove softcenter_module_ddnsto_description
