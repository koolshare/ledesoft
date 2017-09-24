#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

mkdir -p $KSROOT/init.d
mkdir -p /tmp/upload

cp -r /tmp/syncthing/* $KSROOT/
chmod a+x $KSROOT/syncthing/syncthing
chmod a+x $KSROOT/scripts/syncthing_*
chmod a+x $KSROOT/init.d/S97syncthing.sh

# add icon into softerware center
dbus set softcenter_module_syncthing_install=1
dbus set softcenter_module_syncthing_version=0.1
dbus set softcenter_module_syncthing_name=syncthing
dbus set softcenter_module_syncthing_title=syncthing
dbus set softcenter_module_syncthing_description="轻松搭建私有云"
rm -rf $KSROOT/install.sh

# apply aliddns
sh $KSROOT/scripts/syncthing_config.sh start