#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export pppoeai`

confs=`dbus list pppoeai|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/pppoeai*
rm -rf $KSROOT/init.d/S18pppoeai.sh
rm -rf /etc/rc.d/S18pppoeai.sh
rm -rf /etc/hotplug.d/iface/00-pppoeai >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_pppoeai.asp
rm -rf $KSROOT/webs/res/icon-pppoeai.png
rm -rf $KSROOT/webs/res/icon-pppoeai-bg.png

sed -i '/pppoeai/d' /lib/upgrade/keep.d/fwupdate >/dev/null 2>&1 &

dbus remove softcenter_module_pppoeai_home_url
dbus remove softcenter_module_pppoeai_install
dbus remove softcenter_module_pppoeai_md5
dbus remove softcenter_module_pppoeai_version
dbus remove softcenter_module_pppoeai_name
dbus remove softcenter_module_pppoeai_description
