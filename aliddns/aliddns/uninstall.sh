#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export aliddns`

# stop first
sh $KSROOT/scripts/aliddns_config.sh stop

# remove dbus data in softcenter
confs=`dbus list aliddns|cut -d "=" -f1`
for conf in $confs
do
	dbus remove $conf
done

# remove files
rm -rf $KSROOT/scripts/aliddns*
rm -rf $KSROOT/init.d/S98aliddns.sh
rm -rf /etc/rc.d/S98aliddns.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_aliddns.asp
rm -rf $KSROOT/webs/res/icon-aliddns.png
rm -rf $KSROOT/webs/res/icon-aliddns-bg.png

# remove dbus data in frpc
dbus remove softcenter_module_aliddns_home_url
dbus remove softcenter_module_aliddns_install
dbus remove softcenter_module_aliddns_md5
dbus remove softcenter_module_aliddns_version
dbus remove softcenter_module_aliddns_name
dbus remove softcenter_module_aliddns_title
dbus remove softcenter_module_aliddns_description