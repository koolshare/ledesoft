#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export bbr_`

cp -rf /tmp/bbr/scripts/* $KSROOT/scripts/
cp -rf /tmp/bbr/webs/* $KSROOT/webs/
cp /tmp/bbr/uninstall.sh $KSROOT/scripts/uninstall_bbr.sh

chmod +x $KSROOT/scripts/bbr_*

dbus set softcenter_module_bbr_description=魔改BBR
dbus set softcenter_module_bbr_install=1
dbus set softcenter_module_bbr_name=bbr
dbus set softcenter_module_bbr_title="BBR MOD"
dbus set softcenter_module_bbr_version=0.1

sleep 1
rm -rf /tmp/bbr* >/dev/null 2>&1
