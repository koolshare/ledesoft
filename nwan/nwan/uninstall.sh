#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export nwan`

confs=`dbus list nwan|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/nwan*
rm -rf $KSROOT/nwan
rm -rf $KSROOT/webs/Module_nwan.asp
rm -rf $KSROOT/webs/res/icon-nwan.png
rm -rf $KSROOT/webs/res/icon-nwan-bg.png

dbus remove softcenter_module_nwan_home_url
dbus remove softcenter_module_nwan_install
dbus remove softcenter_module_nwan_md5
dbus remove softcenter_module_nwan_version
dbus remove softcenter_module_nwan_name
dbus remove softcenter_module_nwan_description
rm -rf $KSROOT/scripts/uninstall_nwan.sh
