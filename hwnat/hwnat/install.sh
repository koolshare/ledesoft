#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export hwnat`

mkdir -p $KSROOT/init.d
mkdir -p /tmp/upload

cd /tmp
cp -rf /tmp/hwnat/scripts/* $KSROOT/scripts/
cp -rf /tmp/hwnat/webs/* $KSROOT/webs/
cp /tmp/hwnat/uninstall.sh $KSROOT/scripts/uninstall_hwnat.sh

chmod +x $KSROOT/scripts/hwnat_*

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/scripts/hwnat*

dbus set softcenter_module_hwnat_description=增强路由NAT能力
dbus set softcenter_module_hwnat_install=1
dbus set softcenter_module_hwnat_name=hwnat
dbus set softcenter_module_hwnat_title="NAT硬件加速"
dbus set softcenter_module_hwnat_version=0.1

sleep 1
rm -rf /tmp/hwnat*









