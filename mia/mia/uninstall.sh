#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export mia`

confs=`dbus list mia|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/mia_*
rm -rf $KSROOT/init.d/S99mia.sh
rm -rf /etc/rc.d/S99mia.sh
rm -rf $KSROOT/webs/Module_mia.asp
rm -rf $KSROOT/webs/res/icon-mia.png
rm -rf $KSROOT/webs/res/icon-mia-bg.png

dbus remove softcenter_module_mia_home_url
dbus remove softcenter_module_mia_install
dbus remove softcenter_module_mia_md5
dbus remove softcenter_module_mia_version
dbus remove softcenter_module_mia_name
dbus remove softcenter_module_mia_description
rm -rf $KSROOT/scripts/uninstall_mia.sh
