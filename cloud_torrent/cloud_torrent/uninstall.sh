#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export cloud_torrent_`

# stop first
sh $KSROOT/scripts/cloud_torrent_config.sh stop

# remove dbus data in softcenter
confs=`dbus list cloud_torrent_|cut -d "=" -f1`
for conf in $confs
do
	dbus remove $conf
done

# remove files
rm -rf $KSROOT/bin/cloud-torrent
rm -rf $KSROOT/scripts/cloud_torrent_*
rm -rf $KSROOT/init.d/S77cloud_torrent.sh
rm -rf /etc/rc.d/S77cloud_torrent.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_cloud_torrent.asp
rm -rf $KSROOT/webs/res/icon-cloud_torrent.png
rm -rf $KSROOT/webs/res/icon-cloud_torrent-bg.png

# remove dbus data in cloud_torrent
dbus remove softcenter_module_cloud_torrent_home_url
dbus remove softcenter_module_cloud_torrent_install
dbus remove softcenter_module_cloud_torrent_md5
dbus remove softcenter_module_cloud_torrent_version
dbus remove softcenter_module_cloud_torrent_name
dbus remove softcenter_module_cloud_torrent_title
dbus remove softcenter_module_cloud_torrent_description
