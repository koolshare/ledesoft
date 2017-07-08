#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
cp /tmp/gdddns/res/* $KSROOT/res
cp /tmp/gdddns/scripts/* $KSROOT/scripts
cp /tmp/gdddns/webs/* $KSROOT/webs
cp /tmp/gdddns/bin/* $KSROOT/bin

chmod a+x $KSROOT/scripts/gdddns_*

# add icon into softerware center
dbus set softcenter_module_gdddns_install=1
dbus set softcenter_module_gdddns_version=1.0.0
dbus set softcenter_module_gdddns_description="Godaddy DDNS"
