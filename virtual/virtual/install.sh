#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export virtual_`

cp -rf /tmp/virtual/scripts/* $KSROOT/scripts/
cp -rf /tmp/virtual/init.d/* $KSROOT/init.d/
cp -rf /tmp/virtual/webs/* $KSROOT/webs/
cp /tmp/virtual/uninstall.sh $KSROOT/scripts/uninstall_virtual.sh

chmod +x $KSROOT/scripts/virtual_*
chmod +x $KSROOT/init.d/S90virtual.sh

dbus set softcenter_module_virtual_description=增强虚拟机操作系统性能
dbus set softcenter_module_virtual_install=1
dbus set softcenter_module_virtual_name=virtual
dbus set softcenter_module_virtual_title="虚拟机助手"
dbus set softcenter_module_virtual_version=0.1

sleep 1
rm -rf /tmp/virtual* >/dev/null 2>&1
