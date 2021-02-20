#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export uuacc`

mkdir -p $KSROOT/init.d
mkdir -p $KSROOT/scripts
mkdir -p $KSROOT/uu
mkdir -p /tmp/upload

cd /tmp
cp -rf /tmp/uuacc/scripts/* $KSROOT/scripts/
cp -rf /tmp/uuacc/uu/* $KSROOT/uu/
cp -rf /tmp/uuacc/init.d/* $KSROOT/init.d/
cp -rf /tmp/uuacc/webs/* $KSROOT/webs/
cp /tmp/uuacc/uninstall.sh $KSROOT/scripts/uninstall_uuacc.sh

chmod +x $KSROOT/scripts/uuacc*.sh
chmod +x $KSROOT/uu/uuplugin_monitor.sh
chmod +x $KSROOT/init.d/S99uuacc.sh

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/scripts/uuacc*

dbus set softcenter_module_uuacc_description=一键开启全球联机之旅
dbus set softcenter_module_uuacc_install=1
dbus set softcenter_module_uuacc_name=uuacc
dbus set softcenter_module_uuacc_title=UU游戏加速器
dbus set softcenter_module_uuacc_version=0.1

# make uuacc restart/stop to apply change
sh /koolshare/scripts/uuacc_config.sh

sleep 1
rm -rf /tmp/uuacc* >/dev/null 2>&1










