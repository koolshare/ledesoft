#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export unifi`

confs=`dbus list unifi|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/unifi*
rm -rf $KSROOT/init.d/S99unifi.sh
rm -rf $KSROOT/webs/Module_unifi.asp
rm -rf $KSROOT/webs/res/icon-unifi.png
rm -rf $KSROOT/webs/res/icon-unifi-bg.png
rm -rf $KSROOT/scripts/uninstall_unifi.sh
rm -rf /etc/rc.d/S99unifi.sh

dbus remove softcenter_module_unifi_home_url
dbus remove softcenter_module_unifi_install
dbus remove softcenter_module_unifi_md5
dbus remove softcenter_module_unifi_version
dbus remove softcenter_module_unifi_name
dbus remove softcenter_module_unifi_description
