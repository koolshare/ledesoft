#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export pppoeserver_`

mkdir -p $KSROOT/init.d
cp -rf /tmp/pppoeserver/init.d/* $KSROOT/init.d/
cp -rf /tmp/pppoeserver/scripts/* $KSROOT/scripts/
cp -rf /tmp/pppoeserver/webs/* $KSROOT/webs/
cp /tmp/pppoeserver/uninstall.sh $KSROOT/scripts/uninstall_pppoeserver.sh

chmod +x $KSROOT/scripts/pppoeserver_*
chmod +x $KSROOT/init.d/S99pppoeserver.sh

dbus set softcenter_module_pppoeserver_description=PPPoE服务器
dbus set softcenter_module_pppoeserver_install=1
dbus set softcenter_module_pppoeserver_name=pppoeserver
dbus set softcenter_module_pppoeserver_title="PPPoE Server"
dbus set softcenter_module_pppoeserver_version=0.1

sleep 1
rm -rf /tmp/pppoeserver >/dev/null 2>&1
