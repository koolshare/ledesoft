#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

rm -rf $KSROOT/scripts/aliddns_*
rm -rf $KSROOT/init.d/S98Aliddns.sh
rm -rf $KSROOT/web/res/icon-aliddns*
rm -rf $KSROOT/web/Module_aliddns.asp

cp -r /tmp/aliddns/* $KSROOT/
chmod a+x $KSROOT/scripts/aliddns_*
chmod a+x $KSROOT/init.d/S98aliddns.sh

cp /tmp/aliddns/uninstall.sh $KSROOT/scripts/uninstall_aliddns.sh

# add icon into softerware center
dbus set softcenter_module_aliddns_install=1
dbus set softcenter_module_aliddns_version=0.1
dbus set softcenter_module_aliddns_name=aliddns
dbus set softcenter_module_aliddns_title=aliddns
dbus set softcenter_module_aliddns_description="阿里云解析自动更新IP"

rm -rf $KSROOT/install.sh

# remove old files if exist
find /etc/rc.d/ -name *aliddns.sh* | xargs rm -rf

# apply aliddns
sh $KSROOT/scripts/aliddns_config.sh start
