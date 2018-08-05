#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

mkdir -p $KSROOT/smzdm
cp -rf /tmp/smzdm/scripts/* $KSROOT/scripts/
cp -rf /tmp/smzdm/webs/* $KSROOT/webs/
cp -rf /tmp/smzdm/init.d/* $KSROOT/init.d/
cp -rf /tmp/smzdm/smzdm/* $KSROOT/smzdm/
cp /tmp/smzdm/uninstall.sh $KSROOT/scripts/uninstall_smzdm.sh

chmod +x $KSROOT/scripts/smzdm_*

dbus set softcenter_module_smzdm_description=每日批量自动签到
dbus set softcenter_module_smzdm_install=1
dbus set softcenter_module_smzdm_name=smzdm
dbus set softcenter_module_smzdm_title="什么值得买"
dbus set softcenter_module_smzdm_version=0.1

sleep 1
rm -rf /tmp/smzdm >/dev/null 2>&1
