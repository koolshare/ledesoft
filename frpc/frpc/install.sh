#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export frpc`

[ "$frpc_enable" == "1" ] && sh $KSROOT/scripts/frpc_config.sh stop

sleep 1

cp -r /tmp/frpc/* $KSROOT/

chmod a+x $KSROOT/scripts/frpc_*
chmod a+x $KSROOT/init.d/*
chmod a+x $KSROOT/frpc/frpc

# add icon into softerware center
dbus set softcenter_module_frpc_install=1
dbus set softcenter_module_frpc_version=1.2
dbus set softcenter_module_frpc_name=frpc
dbus set softcenter_module_frpc_title=frpc
dbus set softcenter_module_frpc_description="frp内网穿透客户端"

rm -rf $KSROOT/install.sh

#remove old files if exist
find /etc/rc.d/ -name *frpc.sh* | xargs rm -rf

[ "$frpc_enable" == "1" ] && sh $KSROOT/scripts/frpc_config.sh start

return 0