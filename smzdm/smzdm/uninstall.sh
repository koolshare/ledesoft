#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export smzdm`

confs=`dbus list smzdm|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/smzdm*
rm -rf $KSROOT/init.d/S99smzdm.sh
rm -rf $KSROOT/smzdm
rm -rf $KSROOT/webs/Module_smzdm.asp
rm -rf $KSROOT/webs/res/icon-smzdm.png
rm -rf $KSROOT/webs/res/icon-smzdm-bg.png
rm -rf /etc/rc.d/S99smzdm.sh >/dev/null 2>&1

dbus remove softcenter_module_smzdm_home_url
dbus remove softcenter_module_smzdm_install
dbus remove softcenter_module_smzdm_md5
dbus remove softcenter_module_smzdm_version
dbus remove softcenter_module_smzdm_name
dbus remove softcenter_module_smzdm_description
rm -rf $KSROOT/scripts/uninstall_smzdm.sh
