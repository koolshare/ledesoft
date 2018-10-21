#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export ikev1`

confs=`dbus list ikev1|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/ikev1*
rm -rf $KSROOT/init.d/S99ikev1.sh
rm -rf /etc/rc.d/S99ikev1.sh
rm -rf $KSROOT/webs/Module_ikev1.asp
rm -rf $KSROOT/webs/res/icon-ikev1.png
rm -rf $KSROOT/webs/res/icon-ikev1-bg.png

dbus remove softcenter_module_ikev1_home_url
dbus remove softcenter_module_ikev1_install
dbus remove softcenter_module_ikev1_md5
dbus remove softcenter_module_ikev1_version
dbus remove softcenter_module_ikev1_name
dbus remove softcenter_module_ikev1_description

rm -rf $KSROOT/scripts/uninstall_ikev1.sh
