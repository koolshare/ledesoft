#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export minieap`

confs=`dbus list minieap|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/minieap*
rm -rf $KSROOT/bin/minieap
rm -rf $KSROOT/init.d/S99minieap.sh
rm -rf /etc/rc.d/S99minieap.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_minieap.asp
rm -rf $KSROOT/webs/res/icon-minieap.png
rm -rf $KSROOT/webs/res/icon-minieap-bg.png
rm -rf $KSROOT/scripts/uninstall_minieap.sh

dbus remove softcenter_module_minieap_home_url
dbus remove softcenter_module_minieap_install
dbus remove softcenter_module_minieap_md5
dbus remove softcenter_module_minieap_version
dbus remove softcenter_module_minieap_name
dbus remove softcenter_module_minieap_description
