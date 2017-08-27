#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export dnspod`

# stop first
sh $KSROOT/scripts/dnspod_config.sh stop

# remove dbus data in softcenter
confs=`dbus list dnspod|cut -d "=" -f1`
for conf in $confs
do
	dbus remove $conf
done

# remove files
rm -rf $KSROOT/scripts/dnspod*
rm -rf $KSROOT/init.d/S98dnspod.sh
rm -rf /etc/rc.d/S98dnspod.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_dnspod.asp
rm -rf $KSROOT/webs/res/icon-dnspod.png
rm -rf $KSROOT/webs/res/icon-dnspod-bg.png

# remove dbus data in frpc
dbus remove softcenter_module_dnspod_home_url
dbus remove softcenter_module_dnspod_install
dbus remove softcenter_module_dnspod_md5
dbus remove softcenter_module_dnspod_version
dbus remove softcenter_module_dnspod_name
dbus remove softcenter_module_dnspod_title
dbus remove softcenter_module_dnspod_description