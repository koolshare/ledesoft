#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export homeassistant`

confs=`dbus list homeassistant|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/homeassistant*
rm -rf $KSROOT/init.d/S98homeassistant.sh
rm -rf /etc/rc.d/S98homeassistant.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_homeassistant.asp
rm -rf $KSROOT/webs/res/icon-homeassistant.png
rm -rf $KSROOT/webs/res/icon-homeassistant-bg.png
rm -rf $KSROOT/homeassistant
rm -rf /usr/lib/node_modules/homeassistant*

dbus remove softcenter_module_homeassistant_home_url
dbus remove softcenter_module_homeassistant_install
dbus remove softcenter_module_homeassistant_md5
dbus remove softcenter_module_homeassistant_version
dbus remove softcenter_module_homeassistant_name
dbus remove softcenter_module_homeassistant_description
