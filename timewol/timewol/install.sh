#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export timewol_`

cp -rf /tmp/timewol/scripts/* $KSROOT/scripts/
cp -rf /tmp/timewol/webs/* $KSROOT/webs/
cp /tmp/timewol/uninstall.sh $KSROOT/scripts/uninstall_timewol.sh

chmod +x $KSROOT/scripts/timewol_*

dbus set softcenter_module_timewol_description=在指定时间唤醒设备
dbus set softcenter_module_timewol_install=1
dbus set softcenter_module_timewol_name=timewol
dbus set softcenter_module_timewol_title="定时唤醒"
dbus set softcenter_module_timewol_version=0.1

sleep 1
rm -rf /tmp/timewol >/dev/null 2>&1
