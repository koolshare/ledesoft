#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export pppoerelay`

mkdir -p $KSROOT/init.d
mkdir -p /tmp/upload

cd /tmp
cp -rf /tmp/pppoerelay/bin/* $KSROOT/bin/
cp -rf /tmp/pppoerelay/scripts/* $KSROOT/scripts/
cp -rf /tmp/pppoerelay/init.d/* $KSROOT/init.d/
cp -rf /tmp/pppoerelay/webs/* $KSROOT/webs/
cp /tmp/pppoerelay/uninstall.sh $KSROOT/scripts/uninstall_pppoerelay.sh

chmod +x $KSROOT/bin/pppoe-relay
chmod +x $KSROOT/scripts/pppoerelay_*
chmod +x $KSROOT/init.d/S97pppoerelay.sh

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/scripts/pppoerelay*

dbus set softcenter_module_pppoerelay_description=使PPPoE能够跨路由使用
dbus set softcenter_module_pppoerelay_install=1
dbus set softcenter_module_pppoerelay_name=pppoerelay
dbus set softcenter_module_pppoerelay_title=PPPoE Relay
dbus set softcenter_module_pppoerelay_version=0.1

# make pppoerelay restart/stop to apply change
sh /koolshare/scripts/pppoerelay_config.sh

sleep 1
rm -rf /tmp/pppoerelay* >/dev/null 2>&1










