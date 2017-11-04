#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export anyconnect`

confs=`dbus list anyconnect|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/anyconnect_*
rm -rf $KSROOT/webs/Module_anyconnect.asp
rm -rf $KSROOT/webs/res/icon-anyconnect.png
rm -rf $KSROOT/webs/res/icon-anyconnect-bg.png

dbus remove softcenter_module_anyconnect_home_url
dbus remove softcenter_module_anyconnect_install
dbus remove softcenter_module_anyconnect_md5
dbus remove softcenter_module_anyconnect_version
dbus remove softcenter_module_anyconnect_name
dbus remove softcenter_module_anyconnect_description

opkg remove ocserv
[ -f $KSROOT/webs/files/ca.crt ] && rm -rf $KSROOT/webs/files/ca.crt
[ -f $KSROOT/webs/files/anyconnect.p12 ] && rm -rf $KSROOT/webs/files/anyconnect.p12

rm -rf $KSROOT/scripts/uninstall_anyconnect.sh
