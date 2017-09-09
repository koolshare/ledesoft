#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

mkdir -p $KSROOT/init.d
mkdir -p /tmp/upload

cp /tmp/gdddns/scripts/* $KSROOT/scripts
cp /tmp/gdddns/webs/* $KSROOT/webs
cp /tmp/gdddns/init.d/* $KSROOT/init.d

chmod a+x $KSROOT/scripts/gdddns_*
chmod a+x $KSROOT/init.d/S98gddns.sh

# remove old files if exist
find /etc/rc.d/ -name *gdddns.sh* | xargs rm -rf

# add icon into softerware center
dbus set softcenter_module_gdddns_install=1
dbus set softcenter_module_gdddns_version=1.0.0
dbus set softcenter_module_gdddns_description="Godaddy DDNS"
