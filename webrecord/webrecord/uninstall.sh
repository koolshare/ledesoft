#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export webrecord`

confs=`dbus list webrecord|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/webrecord_*
rm -rf $KSROOT/webs/Module_webrecord.asp
rm -rf $KSROOT/webs/res/icon-webrecord.png
rm -rf $KSROOT/webs/res/icon-webrecord-bg.png
rm -rf $KSROOT/init.d/S99webrecord.sh
rm -rf /etc/rc.d/S99webrecord.sh

dbus remove softcenter_module_webrecord_home_url
dbus remove softcenter_module_webrecord_install
dbus remove softcenter_module_webrecord_md5
dbus remove softcenter_module_webrecord_version
dbus remove softcenter_module_webrecord_name
dbus remove softcenter_module_webrecord_description
rm -rf $KSROOT/scripts/uninstall_webrecord.sh
