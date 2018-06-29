#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export nat1`

confs=`dbus list nat1|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/nat1*
rm -rf $KSROOT/webs/Module_nat1.asp
rm -rf $KSROOT/webs/res/icon-nat1.png
rm -rf $KSROOT/webs/res/icon-nat1-bg.png
rm -rf $KSROOT/scripts/uninstall_nat1.sh

dbus remove softcenter_module_nat1_home_url
dbus remove softcenter_module_nat1_install
dbus remove softcenter_module_nat1_md5
dbus remove softcenter_module_nat1_version
dbus remove softcenter_module_nat1_name
dbus remove softcenter_module_nat1_description
