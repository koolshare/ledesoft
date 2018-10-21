#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export hwnat`

confs=`dbus list hwnat|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/hwnat*
rm -rf $KSROOT/init.d/S94hwnat.sh
rm -rf /etc/rc.d/S72hwnat.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_hwnat.asp
rm -rf $KSROOT/webs/res/icon-hwnat.png
rm -rf $KSROOT/webs/res/icon-hwnat-bg.png

dbus remove softcenter_module_hwnat_home_url
dbus remove softcenter_module_hwnat_install
dbus remove softcenter_module_hwnat_md5
dbus remove softcenter_module_hwnat_version
dbus remove softcenter_module_hwnat_name
dbus remove softcenter_module_hwnat_description
