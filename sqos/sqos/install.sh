#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

cp -rf /tmp/sqos/init.d/* $KSROOT/init.d/
cp -rf /tmp/sqos/scripts/* $KSROOT/scripts/
cp -rf /tmp/sqos/webs/* $KSROOT/webs/
cp -rf /tmp/sqos/hotplug/* /etc/hotplug.d/iface/
cp /tmp/sqos/uninstall.sh $KSROOT/scripts/uninstall_sqos.sh

chmod +x $KSROOT/scripts/sqos_*
chmod +x $KSROOT/init.d/S98sqos.sh

dbus set softcenter_module_sqos_description="宽带限速、优化"
dbus set softcenter_module_sqos_install=1
dbus set softcenter_module_sqos_name=sqos
dbus set softcenter_module_sqos_title="QOS"
dbus set softcenter_module_sqos_version=0.1

sleep 1
rm -rf /tmp/sqos >/dev/null 2>&1
