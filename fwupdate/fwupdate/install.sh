#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

# copy new files
cd /tmp
cp -rf /tmp/fwupdate/scripts/* $KSROOT/scripts/
cp -rf /tmp/fwupdate/webs/* $KSROOT/webs/
cp -rf /tmp/fwupdate/keep.d/* /lib/upgrade/keep.d/
cp /tmp/fwupdate/uninstall.sh $KSROOT/scripts/uninstall_fwupdate.sh

rm -rf $KSROOT/install.sh

chmod 755 $KSROOT/scripts/*

rm -rf /tmp/fwupdate* >/dev/null 2>&1

# add icon into softerware center
dbus set softcenter_module_fwupdate_install=1
dbus set softcenter_module_fwupdate_name=fwupdate
dbus set softcenter_module_fwupdate_title=固件更新
dbus set softcenter_module_fwupdate_description=在线更新路由器固件
dbus set softcenter_module_fwupdate_home_url="Module_fwupdate.asp"
dbus set softcenter_module_fwupdate_version=0.1.5
dbus set fwupdate_lastcheck=0
dbus set fwupdate_keep=1
