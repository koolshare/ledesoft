#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export serverchan`

cp -r /tmp/serverchan/* $KSROOT/
chmod a+x $KSROOT/scripts/serverchan*


# add icon into softerware center
dbus set softcenter_module_serverchan_install=1
dbus set softcenter_module_serverchan_version="1.0.0"
dbus set softcenter_module_serverchan_name=serverchan
dbus set softcenter_module_serverchan_title="Server酱"
dbus set softcenter_module_serverchan_description="推送路由器信息到微信~"

rm -rf $KSROOT/install.sh

# apply frpc
/koolshare/scripts/serverchan_config.sh ks start

return 0