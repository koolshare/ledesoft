#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export lnmp`

confs=`dbus list lnmp|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/lnmp*
rm -rf $KSROOT/lnmp
rm -rf $KSROOT/init.d/S99lnmp.sh
rm -rf /etc/rc.d/S99lnmp.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_lnmp.asp
rm -rf $KSROOT/webs/res/icon-lnmp.png
rm -rf $KSROOT/webs/res/icon-lnmp-bg.png

dbus remove softcenter_module_lnmp_home_url
dbus remove softcenter_module_lnmp_install
dbus remove softcenter_module_lnmp_md5
dbus remove softcenter_module_lnmp_version
dbus remove softcenter_module_lnmp_name
dbus remove softcenter_module_lnmp_description
