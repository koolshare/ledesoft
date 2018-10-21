#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export cos`

confs=`dbus list cos|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/cos*
rm -rf $KSROOT/bin/tgtd
rm -rf $KSROOT/bin/tgtadm
rm -rf $KSROOT/init.d/S99cos.sh
rm -rf /etc/rc.d/S99cos.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_cos.asp
rm -rf $KSROOT/webs/res/icon-cos.png
rm -rf $KSROOT/webs/res/icon-cos-bg.png

dbus remove softcenter_module_cos_home_url
dbus remove softcenter_module_cos_install
dbus remove softcenter_module_cos_md5
dbus remove softcenter_module_cos_version
dbus remove softcenter_module_cos_name
dbus remove softcenter_module_cos_description

rm -rf $KSROOT/scripts/uninstall_cos.sh
