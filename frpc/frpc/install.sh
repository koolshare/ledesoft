#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

cp -r /tmp/frpc/* $KSROOT/
chmod a+x $KSROOT/scripts/frpc_*
chmod a+x $KSROOT/frpc/frpc

# add icon into softerware center
dbus set softcenter_module_frpc_install=1
dbus set softcenter_module_frpc_version=0.1
dbus set softcenter_module_frpc_description="frp内网穿透客户端"
rm -rf $KSROOT/install.sh