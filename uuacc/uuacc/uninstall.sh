#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export uuacc`

confs=`dbus list uuacc|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/uu
rm -rf $KSROOT/scripts/uuacc*
rm -rf $KSROOT/init.d/S99uuacc.sh
rm -rf /etc/rc.d/S99uuacc.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_uuacc.asp
rm -rf $KSROOT/webs/res/icon-uuacc.png
rm -rf $KSROOT/webs/res/icon-uuacc-bg.png

dbus remove softcenter_module_uuacc_home_url
dbus remove softcenter_module_uuacc_install
dbus remove softcenter_module_uuacc_md5
dbus remove softcenter_module_uuacc_version
dbus remove softcenter_module_uuacc_name
dbus remove softcenter_module_uuacc_description
