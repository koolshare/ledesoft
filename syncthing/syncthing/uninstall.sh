#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export syncthing_`

# stop first
sh $KSROOT/scripts/syncthing__config.sh stop

# remove dbus data in softcenter
confs=`dbus list syncthing_|cut -d "=" -f1`
for conf in $confs
do
	dbus remove $conf
done

# remove files
rm -rf $KSROOT/syncthing
rm -rf $KSROOT/scripts/syncthing*
rm -rf $KSROOT/init.d/S97syncthing.sh
rm -rf /etc/rc.d/S97syncthing.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_syncthing.asp
rm -rf $KSROOT/webs/res/icon-syncthing.png
rm -rf $KSROOT/webs/res/icon-syncthing-bg.png

# remove dbus data in syncthing
dbus remove softcenter_module_syncthing_home_url
dbus remove softcenter_module_syncthing_install
dbus remove softcenter_module_syncthing_md5
dbus remove softcenter_module_syncthing_version
dbus remove softcenter_module_syncthing_name
dbus remove softcenter_module_syncthing_title
dbus remove softcenter_module_syncthing_description
