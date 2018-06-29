#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export easyexplorer`

confs=`dbus list easyexplorer|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/bin/easyexplorer
rm -rf $KSROOT/bin/video_mux
rm -rf $KSROOT/scripts/easyexplorer*
rm -rf $KSROOT/init.d/S99easyexplorer.sh
rm -rf /etc/rc.d/S99easyexplorer.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_easyexplorer.asp
rm -rf $KSROOT/webs/res/icon-easyexplorer.png
rm -rf $KSROOT/webs/res/icon-easyexplorer-bg.png

dbus remove softcenter_module_easyexplorer_home_url
dbus remove softcenter_module_easyexplorer_install
dbus remove softcenter_module_easyexplorer_md5
dbus remove softcenter_module_easyexplorer_version
dbus remove softcenter_module_easyexplorer_name
dbus remove softcenter_module_easyexplorer_description
