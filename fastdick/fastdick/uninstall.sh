#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export fastdick`

confs=`dbus list fastdick|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/fastdick*
rm -rf $KSROOT/fastdick
rm -rf $KSROOT/init.d/S99fastdick.sh
rm -rf /etc/rc.d/S99fastdick.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_fastdick.asp
rm -rf $KSROOT/webs/res/icon-fastdick.png
rm -rf $KSROOT/webs/res/icon-fastdick-bg.png
rm -rf $KSROOT/scripts/uninstall_fastdick.sh

dbus remove softcenter_module_fastdick_home_url
dbus remove softcenter_module_fastdick_install
dbus remove softcenter_module_fastdick_md5
dbus remove softcenter_module_fastdick_version
dbus remove softcenter_module_fastdick_name
dbus remove softcenter_module_fastdick_description
