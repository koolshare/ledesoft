#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

cd /tmp
cp -rf /tmp/pppoeai/scripts/* $KSROOT/scripts/
cp -rf /tmp/pppoeai/init.d/* $KSROOT/init.d/
cp -rf /tmp/pppoeai/webs/* $KSROOT/webs/
cp /tmp/pppoeai/uninstall.sh $KSROOT/scripts/uninstall_pppoeai.sh

chmod +x $KSROOT/scripts/pppoeai_*

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/scripts/pppoeai*

dbus set softcenter_module_pppoeai_description=拨号到指定号段
dbus set softcenter_module_pppoeai_install=1
dbus set softcenter_module_pppoeai_name=pppoeai
dbus set softcenter_module_pppoeai_title=拨号助手
dbus set softcenter_module_pppoeai_version=0.1

sed -i '/pppoeai/d' /lib/upgrade/keep.d/fwupdate >/dev/null 2>&1 &
echo "/etc/hotplug.d/iface/00-pppoeai" >> /lib/upgrade/keep.d/fwupdate
# make pppoeai restart/stop to apply change
sh /koolshare/scripts/pppoeai_getwan.sh

sleep 1
rm -rf /tmp/pppoeai* >/dev/null 2>&1
