#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export dmz`

mkdir -p $KSROOT/init.d
mkdir -p /tmp/upload

cd /tmp
cp -rf /tmp/dmz/scripts/* $KSROOT/scripts/
cp -rf /tmp/dmz/init.d/* $KSROOT/init.d/
cp -rf /tmp/dmz/webs/* $KSROOT/webs/
cp /tmp/dmz/uninstall.sh $KSROOT/scripts/uninstall_dmz.sh

chmod +x $KSROOT/scripts/dmz_*
chmod +x $KSROOT/init.d/S80dmz.sh

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/scripts/dmz*

rm -rf $KSROOT/init.d/S90dmz
rm -rf /etc/rc.d/S90dmz
opkg remove luci-i18n-dmz-zh-cn luci-app-dmz 
dbus set softcenter_module_dmz_description=将客户端完全暴露在公网
dbus set softcenter_module_dmz_install=1
dbus set softcenter_module_dmz_name=dmz
dbus set softcenter_module_dmz_title=DMZ
dbus set softcenter_module_dmz_version=0.1

# make dmz restart/stop to apply change
sh /koolshare/scripts/dmz_config.sh

sleep 1
rm -rf /tmp/dmz* >/dev/null 2>&1










