#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export xldoc`

mkdir -p /tmp/upload

cd /tmp
cp -rf /tmp/xldoc/scripts/* $KSROOT/scripts/
cp -rf /tmp/xldoc/webs/* $KSROOT/webs/
cp /tmp/xldoc/uninstall.sh $KSROOT/scripts/uninstall_xldoc.sh

chmod +x $KSROOT/scripts/xldoc_*

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/scripts/xldoc*

dbus set softcenter_module_xldoc_description=修复迅雷不能下载的BUG
dbus set softcenter_module_xldoc_install=1
dbus set softcenter_module_xldoc_name=xldoc
dbus set softcenter_module_xldoc_title=救救迅雷
dbus set softcenter_module_xldoc_version=0.1

sleep 1
rm -rf /tmp/xldoc* >/dev/null 2>&1










