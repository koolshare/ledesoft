#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export kms`

# stop first
sh $KSROOT/scripts/kms_config.sh stop

# remove dbus data in softcenter
confs=`dbus list kms|cut -d "=" -f1`
for conf in $confs
do
	dbus remove $conf
done

# remove files
rm -rf $KSROOT/bin/vlmcsd
rm -rf $KSROOT/webs/res/icon-kms*
rm -rf $KSROOT/scripts/kms*
rm -rf $KSROOT/webs/Module_kms.asp
rm -rf $KSROOT/init.d/S97kms.sh
rm -rf /etc/rc.d/S97kms.sh >/dev/null 2>&1

# remove dbus data in frpc
dbus remove softcenter_module_frpc_home_url
dbus remove softcenter_module_frpc_install
dbus remove softcenter_module_frpc_md5
dbus remove softcenter_module_frpc_version
dbus remove softcenter_module_frpc_name
dbus remove softcenter_module_frpc_title
dbus remove softcenter_module_frpc_description