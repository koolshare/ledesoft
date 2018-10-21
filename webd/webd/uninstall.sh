#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export webd_`

# stop first
sh $KSROOT/scripts/webd_config.sh stop

# remove dbus data in softcenter
confs=`dbus list webd_|cut -d "=" -f1`
for conf in $confs
do
	dbus remove $conf
done

# remove files
rm -rf $KSROOT/bin/webd
rm -rf $KSROOT/scripts/webd_*
rm -rf $KSROOT/init.d/S99webd.sh
rm -rf /etc/rc.d/S99webd.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_webd.asp
rm -rf $KSROOT/webs/res/icon-webd.png
rm -rf $KSROOT/webs/res/icon-webd-bg.png

# remove dbus data in webd
dbus remove softcenter_module_webd_home_url
dbus remove softcenter_module_webd_install
dbus remove softcenter_module_webd_md5
dbus remove softcenter_module_webd_version
dbus remove softcenter_module_webd_name
dbus remove softcenter_module_webd_title
dbus remove softcenter_module_webd_description
