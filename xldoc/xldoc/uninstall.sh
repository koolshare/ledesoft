#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export xldoc`

confs=`dbus list xldoc|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/xldoc*
rm -rf $KSROOT/webs/Module_xldoc.asp
rm -rf $KSROOT/webs/res/icon-xldoc.png
rm -rf $KSROOT/webs/res/icon-xldoc-bg.png

dbus remove softcenter_module_xldoc_home_url
dbus remove softcenter_module_xldoc_install
dbus remove softcenter_module_xldoc_md5
dbus remove softcenter_module_xldoc_version
dbus remove softcenter_module_xldoc_name
dbus remove softcenter_module_xldoc_description
