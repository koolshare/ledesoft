#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export acme`

confs=`dbus list acme|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/acme*
rm -rf $KSROOT/acme
rm -rf $KSROOT/webs/Module_acme.asp
rm -rf $KSROOT/webs/res/icon-acme.png
rm -rf $KSROOT/webs/res/icon-acme-bg.png
rm -rf $KSROOT/scripts/uninstall_acme.sh

dbus remove softcenter_module_acme_home_url
dbus remove softcenter_module_acme_install
dbus remove softcenter_module_acme_md5
dbus remove softcenter_module_acme_version
dbus remove softcenter_module_acme_name
dbus remove softcenter_module_acme_description
