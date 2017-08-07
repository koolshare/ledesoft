#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export frpc`

confs=`dbus list frpc|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1


rm -rf $KSROOT/scripts/frpc*
rm -rf $KSROOT/init.d/S95frpc.sh
rm -rf /etc/rc.d/S95frpc.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_frpc.asp
rm -rf $KSROOT/webs/res/icon-ddnsto.png
rm -rf $KSROOT/webs/res/icon-ddnsto-bg.png

dbus remove softcenter_module_frpc_home_url
dbus remove softcenter_module_frpc_install
dbus remove softcenter_module_frpc_md5
dbus remove softcenter_module_frpc_version
dbus remove softcenter_module_frpc_name
dbus remove softcenter_module_frpc_title
dbus remove softcenter_module_frpc_description