#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export transmission`

confs=`dbus list transmission|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/transmission_*
rm -rf $KSROOT/webs/Module_transmission.asp
rm -rf $KSROOT/webs/res/icon-transmission.png
rm -rf $KSROOT/webs/res/icon-transmission-bg.png

dbus remove softcenter_module_transmission_home_url
dbus remove softcenter_module_transmission_install
dbus remove softcenter_module_transmission_md5
dbus remove softcenter_module_transmission_version
dbus remove softcenter_module_transmission_name
dbus remove softcenter_module_transmission_description

opkg remove transmission-web
opkg remove transmission-daemon-openssl

rm -rf /usr/share/transmission

rm -rf $KSROOT/scripts/uninstall_transmission.sh
