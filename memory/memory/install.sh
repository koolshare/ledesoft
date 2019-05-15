#! /bin/sh

export KSROOT=/koolshare

cp -rf /tmp/memory/scripts/* $KSROOT/scripts/
cp -rf /tmp/memory/init.d/* $KSROOT/init.d/
cp -rf /tmp/memory/webs/* $KSROOT/webs/

cp -rf /tmp/memory/uninstall.sh $KSROOT/scripts/uninstall_memory.sh

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/scripts/memory*
chmod 755 $KSROOT/init.d/S98memory.sh
chmod 755 $KSROOT/scripts/uninstall_memory.sh

dbus set softcenter_module_memory_description=内存管理小助手
dbus set softcenter_module_memory_install=1
dbus set softcenter_module_memory_name=memory
dbus set softcenter_module_memory_title=内存管家
dbus set softcenter_module_memory_version=0.1

sleep 1
rm -rf /tmp/memory* >/dev/null 2>&1









