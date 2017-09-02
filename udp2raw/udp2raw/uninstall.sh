#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export udp2raw`

confs=`dbus list udp2raw|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/bin/udp2raw
rm -rf $KSROOT/scripts/udp2raw*
rm -rf $KSROOT/init.d/S88udp2raw.sh
rm -rf /etc/rc.d/S99udp2raw.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_udp2raw.asp
rm -rf $KSROOT/webs/res/icon-udp2raw.png
rm -rf $KSROOT/webs/res/icon-udp2raw-bg.png

dbus remove softcenter_module_udp2raw_home_url
dbus remove softcenter_module_udp2raw_install
dbus remove softcenter_module_udp2raw_md5
dbus remove softcenter_module_udp2raw_version
dbus remove softcenter_module_udp2raw_name
dbus remove softcenter_module_udp2raw_description
