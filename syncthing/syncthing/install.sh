#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

cp -r /tmp/syncthing/* $KSROOT/
chmod a+x $KSROOT/scripts/syncthing_*
chmod a+x $KSROOT/syncthing/syncthing

# add icon into softerware center
dbus set softcenter_module_syncthing_install=1
dbus set softcenter_module_syncthing_version=0.1
dbus set softcenter_module_syncthing_description="多终端同步工具"
rm -rf $KSROOT/install.sh