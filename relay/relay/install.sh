#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export relay_`

mkdir -p $KSROOT/relay
cp -rf /tmp/relay/bin/* $KSROOT/bin/
cp -rf /tmp/relay/init.d/* $KSROOT/init.d/
cp -rf /tmp/relay/scripts/* $KSROOT/scripts/
cp -rf /tmp/relay/webs/* $KSROOT/webs/
cp /tmp/relay/uninstall.sh $KSROOT/scripts/uninstall_relay.sh

chmod +x $KSROOT/scripts/relay_*
chmod +x $KSROOT/init.d/S99relay.sh
chmod +x $KSROOT/bin/socat

[ -z "$relay_node_max" ] && dbus set relay_node_max=0

dbus set softcenter_module_relay_description="端口映射、中转流量"
dbus set softcenter_module_relay_install=1
dbus set softcenter_module_relay_name=relay
dbus set softcenter_module_relay_title="瑞士军刀"
dbus set softcenter_module_relay_version=0.1

sleep 1
rm -rf /tmp/relay* >/dev/null 2>&1
