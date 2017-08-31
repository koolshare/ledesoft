#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export usbmount`

mkdir -p $KSROOT/init.d

cd /tmp
cp -rf /tmp/usbmount/scripts/* $KSROOT/scripts/
cp -rf /tmp/usbmount/webs/* $KSROOT/webs/
cp /tmp/usbmount/uninstall.sh $KSROOT/scripts/uninstall_usbmount.sh

chmod +x $KSROOT/scripts/usbmount_*

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/scripts/usbmount*

dbus set softcenter_module_usbmount_description=将USB磁盘自动挂载到系统
dbus set softcenter_module_usbmount_install=1
dbus set softcenter_module_usbmount_name=usbmount
dbus set softcenter_module_usbmount_title=USB自动挂载
dbus set softcenter_module_usbmount_version=1.0.0

sed -i '/usbmount/d' /lib/upgrade/keep.d/fwupdate >/dev/null 2>&1 &
echo "/etc/hotplug.d/block/20-usbmount" >> /lib/upgrade/keep.d/fwupdate

sleep 1
rm -rf /tmp/usbmount* >/dev/null 2>&1










