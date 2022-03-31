#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export tomodem`

confs=`dbus list tomodem|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/tomodem*
rm -rf $KSROOT/webs/Module_tomodem.asp
rm -rf $KSROOT/webs/res/icon-tomodem.png
rm -rf $KSROOT/webs/res/icon-tomodem-bg.png

dbus remove softcenter_module_tomodem_home_url
dbus remove softcenter_module_tomodem_install
dbus remove softcenter_module_tomodem_md5
dbus remove softcenter_module_tomodem_version
dbus remove softcenter_module_tomodem_name
dbus remove softcenter_module_tomodem_description

rm -rf $KSROOT/scripts/uninstall_tomodem.sh
