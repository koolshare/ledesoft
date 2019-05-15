#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export cloud_torrent_`

mkdir -p $KSROOT/init.d
mkdir -p /tmp/upload

cp -r /tmp/cloud_torrent/* $KSROOT/
chmod a+x $KSROOT/scripts/cloud_torrent_*
chmod a+x $KSROOT/init.d/S77cloud_torrent.sh
chmod a+x $KSROOT/bin/cloud-torrent

# add icon into softerware center
dbus set softcenter_module_cloud_torrent_install=1
dbus set softcenter_module_cloud_torrent_name=cloud_torrent
dbus set softcenter_module_cloud_torrent_title="cloud torrent"
dbus set softcenter_module_cloud_torrent_description="小巧便携BT下载器"
dbus set softcenter_module_cloud_torrent_version=1.0

rm -rf $KSROOT/install.sh

# remove old files if exist
find /etc/rc.d/ -name *cloud_torrent.sh* | xargs rm -rf
[ ! -L "/etc/rc.d/S77cloud_torrent.sh" ] && ln -sf /koolshare/init.d/S77cloud_torrent.sh /etc/rc.d/S77cloud_torrent.sh

# apply cloud_torrent
sh $KSROOT/scripts/cloud_torrent_config.sh start

rm -rf cloud_torrent*
