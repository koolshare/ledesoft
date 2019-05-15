#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export homebridge`

confs=`dbus list homebridge|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/homebridge*
rm -rf $KSROOT/init.d/S98homebridge.sh
rm -rf /etc/rc.d/S98homebridge.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_homebridge.asp
rm -rf $KSROOT/webs/res/icon-homebridge.png
rm -rf $KSROOT/webs/res/icon-homebridge-bg.png
rm -rf $KSROOT/homebridge
rm -rf /usr/lib/node_modules/homebridge*

dbus remove softcenter_module_homebridge_home_url
dbus remove softcenter_module_homebridge_install
dbus remove softcenter_module_homebridge_md5
dbus remove softcenter_module_homebridge_version
dbus remove softcenter_module_homebridge_name
dbus remove softcenter_module_homebridge_description
