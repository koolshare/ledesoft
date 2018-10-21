#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export iscsi`

confs=`dbus list iscsi|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/iscsi*
rm -rf $KSROOT/bin/tgtd
rm -rf $KSROOT/bin/tgtadm
rm -rf $KSROOT/init.d/S99iscsi.sh
rm -rf /etc/rc.d/S99iscsi.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_iscsi.asp
rm -rf $KSROOT/webs/res/icon-iscsi.png
rm -rf $KSROOT/webs/res/icon-iscsi-bg.png
rm -rf $KSROOT/scripts/uninstall_iscsi.sh

dbus remove softcenter_module_iscsi_home_url
dbus remove softcenter_module_iscsi_install
dbus remove softcenter_module_iscsi_md5
dbus remove softcenter_module_iscsi_version
dbus remove softcenter_module_iscsi_name
dbus remove softcenter_module_iscsi_description
