#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export sfe`

confs=`dbus list sfe|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/sfe*
rm -rf $KSROOT/init.d/S94sfe.sh
rm -rf /etc/rc.d/S72sfe.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_sfe.asp
rm -rf $KSROOT/webs/res/icon-sfe.png
rm -rf $KSROOT/webs/res/icon-sfe-bg.png

dbus remove softcenter_module_sfe_home_url
dbus remove softcenter_module_sfe_install
dbus remove softcenter_module_sfe_md5
dbus remove softcenter_module_sfe_version
dbus remove softcenter_module_sfe_name
dbus remove softcenter_module_sfe_description
