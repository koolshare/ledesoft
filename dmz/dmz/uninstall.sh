#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export dmz`

confs=`dbus list dmz|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/bin/dmz
rm -rf $KSROOT/scripts/dmz*
rm -rf $KSROOT/init.d/S88dmz.sh
rm -rf /etc/rc.d/S88dmz.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_dmz.asp
rm -rf $KSROOT/webs/res/icon-dmz.png
rm -rf $KSROOT/webs/res/icon-dmz-bg.png

dbus remove softcenter_module_dmz_home_url
dbus remove softcenter_module_dmz_install
dbus remove softcenter_module_dmz_md5
dbus remove softcenter_module_dmz_version
dbus remove softcenter_module_dmz_name
dbus remove softcenter_module_dmz_description
