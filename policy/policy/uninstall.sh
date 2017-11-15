#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export policy`

confs=`dbus list policy|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/policy*
rm -rf $KSROOT/policy
rm -rf $KSROOT/webs/Module_policy.asp
rm -rf $KSROOT/webs/res/icon-policy.png
rm -rf $KSROOT/webs/res/icon-policy-bg.png

dbus remove softcenter_module_policy_home_url
dbus remove softcenter_module_policy_install
dbus remove softcenter_module_policy_md5
dbus remove softcenter_module_policy_version
dbus remove softcenter_module_policy_name
dbus remove softcenter_module_policy_description
rm -rf $KSROOT/scripts/uninstall_policy.sh
