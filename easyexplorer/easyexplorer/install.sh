#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export easyexplorer`

mkdir -p $KSROOT/init.d
mkdir -p /tmp/upload
rm -rf $KSROOT/bin/video_mux

cd /tmp
cp -rf /tmp/easyexplorer/bin/* $KSROOT/bin/
cp -rf /tmp/easyexplorer/scripts/* $KSROOT/scripts/
cp -rf /tmp/easyexplorer/init.d/* $KSROOT/init.d/
cp -rf /tmp/easyexplorer/webs/* $KSROOT/webs/
cp /tmp/easyexplorer/uninstall.sh $KSROOT/scripts/uninstall_easyexplorer.sh

chmod +x $KSROOT/bin/easyexplorer
chmod +x $KSROOT/bin/video_mux
chmod +x $KSROOT/scripts/easyexplorer_*
chmod +x $KSROOT/init.d/S99easyexplorer.sh

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/scripts/easyexplorer*

dbus set softcenter_module_easyexplorer_description=强大易用的全平台共享工具
dbus set softcenter_module_easyexplorer_install=1
dbus set softcenter_module_easyexplorer_name=easyexplorer
dbus set softcenter_module_easyexplorer_title=EasyeEplorer
dbus set softcenter_module_easyexplorer_version=0.1

# make easyexplorer restart/stop to apply change
sh /koolshare/scripts/easyexplorer_config.sh

sleep 1
rm -rf /tmp/easyexplorer* >/dev/null 2>&1

