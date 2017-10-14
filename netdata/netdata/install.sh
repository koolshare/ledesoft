#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export netdata_`

mkdir -p $KSROOT/init.d
cd /tmp
cp -rf /tmp/netdata/scripts/* $KSROOT/scripts/
cp -rf /tmp/netdata/init.d/* $KSROOT/init.d/
cp -rf /tmp/netdata/webs/* $KSROOT/webs/
cp /tmp/netdata/uninstall.sh $KSROOT/scripts/uninstall_netdata.sh

chmod +x $KSROOT/scripts/netdata_*
chmod +x $KSROOT/init.d/S99netdata.sh

dbus set softcenter_module_netdata_description=监控查看路由详细状态
dbus set softcenter_module_netdata_install=1
dbus set softcenter_module_netdata_name=netdata
dbus set softcenter_module_netdata_title=路由监控
dbus set softcenter_module_netdata_version=0.1

sleep 1
rm -rf /tmp/netdata* >/dev/null 2>&1
