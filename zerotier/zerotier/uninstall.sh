#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export zerotier`

confs=`dbus list zerotier|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/zerotier*
rm -rf $KSROOT/bin/tgtd
rm -rf $KSROOT/bin/tgtadm
rm -rf $KSROOT/init.d/S99zerotier.sh
rm -rf /etc/rc.d/S99zerotier.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_zerotier.asp
rm -rf $KSROOT/webs/res/icon-zerotier.png
rm -rf $KSROOT/webs/res/icon-zerotier-bg.png

dbus remove softcenter_module_zerotier_home_url
dbus remove softcenter_module_zerotier_install
dbus remove softcenter_module_zerotier_md5
dbus remove softcenter_module_zerotier_version
dbus remove softcenter_module_zerotier_name
dbus remove softcenter_module_zerotier_description
opkg remove zerotier

rm -rf $KSROOT/scripts/uninstall_zerotier.sh
