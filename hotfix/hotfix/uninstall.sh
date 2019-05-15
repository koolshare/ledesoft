#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export hotfix`

confs=`dbus list hotfix|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/webs/Module_hotfix.asp
rm -rf $KSROOT/webs/res/icon-hotfix.png
rm -rf $KSROOT/webs/res/icon-hotfix-bg.png

dbus remove softcenter_module_hotfix_home_url
dbus remove softcenter_module_hotfix_install
dbus remove softcenter_module_hotfix_md5
dbus remove softcenter_module_hotfix_version
dbus remove softcenter_module_hotfix_name
dbus remove softcenter_module_hotfix_description
