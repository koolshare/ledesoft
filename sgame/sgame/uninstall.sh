#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export sgame`

confs=`dbus list sgame|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/sgame_*
rm -rf $KSROOT/webs/Module_sgame.asp
rm -rf $KSROOT/webs/res/icon-sgame.png
rm -rf $KSROOT/webs/res/icon-sgame-bg.png
rm -rf $KSROOT/bin/tinyvpn
rm -rf $KSROOT/bin/udp2raw
rm -rf /etc/hotplug.d/iface/30-sgame
rm -rf $KSROOT/sgame

dbus remove softcenter_module_sgame_home_url
dbus remove softcenter_module_sgame_install
dbus remove softcenter_module_sgame_md5
dbus remove softcenter_module_sgame_version
dbus remove softcenter_module_sgame_name
dbus remove softcenter_module_sgame_description

rm -rf $KSROOT/scripts/uninstall_sgame.sh
