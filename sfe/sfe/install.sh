#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export sfe`

mkdir -p $KSROOT/init.d
mkdir -p /tmp/upload

cd /tmp
cp -rf /tmp/sfe/scripts/* $KSROOT/scripts/
cp -rf /tmp/sfe/init.d/* $KSROOT/init.d/
cp -rf /tmp/sfe/webs/* $KSROOT/webs/
cp /tmp/sfe/uninstall.sh $KSROOT/scripts/uninstall_sfe.sh

chmod +x $KSROOT/scripts/sfe_*
chmod +x $KSROOT/init.d/S72sfe.sh

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/scripts/sfe*

dbus set softcenter_module_sfe_description=增强路由NAT能力
dbus set softcenter_module_sfe_install=1
dbus set softcenter_module_sfe_name=sfe
dbus set softcenter_module_sfe_title="SFE快速转发引擎"
dbus set softcenter_module_sfe_version=0.1

sleep 1
rm -rf /tmp/sfe*









