#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export netdata`

confs=`dbus list netdata|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/netdata*
rm -rf $KSROOT/init.d/S99netdata.sh
rm -rf /etc/rc.d/S99netdata.sh
rm -rf $KSROOT/webs/Module_netdata.asp
rm -rf $KSROOT/webs/res/icon-netdata.png
rm -rf $KSROOT/webs/res/icon-netdata-bg.png

dbus remove softcenter_module_netdata_home_url
dbus remove softcenter_module_netdata_install
dbus remove softcenter_module_netdata_md5
dbus remove softcenter_module_netdata_version
dbus remove softcenter_module_netdata_name
dbus remove softcenter_module_netdata_description

rm -rf $KSROOT/scripts/uninstall_netdata.sh
