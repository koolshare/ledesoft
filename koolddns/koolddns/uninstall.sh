#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export koolddns`

confs=`dbus list koolddns|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/koolddns*
rm -rf $KSROOT/init.d/S99koolddns.sh
rm -rf /etc/rc.d/S99koolddns.sh
rm -rf $KSROOT/webs/Module_koolddns.asp
rm -rf $KSROOT/webs/res/icon-koolddns.png
rm -rf $KSROOT/webs/res/icon-koolddns-bg.png
rm -rf $KSROOT/scripts/uninstall_koolddns.sh

dbus remove softcenter_module_koolddns_home_url
dbus remove softcenter_module_koolddns_install
dbus remove softcenter_module_koolddns_md5
dbus remove softcenter_module_koolddns_version
dbus remove softcenter_module_koolddns_name
dbus remove softcenter_module_koolddns_description
