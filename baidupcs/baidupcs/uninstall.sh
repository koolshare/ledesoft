#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export baidupcs`

confs=`dbus list baidupcs|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/bin/baidupcs
rm -rf $KSROOT/scripts/baidupcs*
rm -rf $KSROOT/init.d/S99baidupcs.sh
rm -rf /etc/rc.d/S99baidupcs.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_baidupcs.asp
rm -rf $KSROOT/webs/res/icon-baidupcs.png
rm -rf $KSROOT/webs/res/icon-baidupcs-bg.png

dbus remove softcenter_module_baidupcs_home_url
dbus remove softcenter_module_baidupcs_install
dbus remove softcenter_module_baidupcs_md5
dbus remove softcenter_module_baidupcs_version
dbus remove softcenter_module_baidupcs_name
dbus remove softcenter_module_baidupcs_description
