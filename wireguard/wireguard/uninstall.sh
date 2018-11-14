#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export wireguard`

confs=`dbus list wireguard|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/wireguard*
rm -rf $KSROOT/init.d/S99wireguard.sh
rm -rf $KSROOT/wireguard
rm -rf $KSROOT/webs/Module_wireguard.asp
rm -rf $KSROOT/webs/res/icon-wireguard.png
rm -rf $KSROOT/webs/res/icon-wireguard-bg.png
rm -rf $KSROOT/scripts/uninstall_wireguard.sh

dbus remove softcenter_module_wireguard_home_url
dbus remove softcenter_module_wireguard_install
dbus remove softcenter_module_wireguard_md5
dbus remove softcenter_module_wireguard_version
dbus remove softcenter_module_wireguard_name
dbus remove softcenter_module_wireguard_description
