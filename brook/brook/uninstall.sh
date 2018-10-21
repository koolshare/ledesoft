#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

confs=`dbus list brook | cut -d "=" -f 1 | grep -v "version"`
for conf in $confs
do
	dbus remove $conf
done

sleep 1

rm -rf $KSROOT/init.d/S98brook.sh >/dev/null 2>&1
rm -rf /etc/rc.d/S98brook.sh >/dev/null 2>&1
rm -rf $KSROOT/scripts/brook_*  >/dev/null 2>&1
rm -rf $KSROOT/scripts/uninstall_brook.sh  >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_brook.asp  >/dev/null 2>&1
rm -rf $KSROOT/webs/res/icon-brook*  >/dev/null 2>&1
rm -rf $KSROOT/bin/brook  >/dev/null 2>&1
rm -rf $KSROOT/bin/redsocks2  >/dev/null 2>&1
rm -rf $KSROOT/bin/dnsforwarder  >/dev/null 2>&1
rm -rf $KSROOT/configs/brook*

dbus remove softcenter_module_brook_description
dbus remove softcenter_module_brook_install
dbus remove softcenter_module_brook_name
dbus remove softcenter_module_brook_title
dbus remove softcenter_module_brook_version
