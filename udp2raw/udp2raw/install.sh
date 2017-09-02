#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export udp2raw`

mkdir -p $KSROOT/init.d

cd /tmp
cp -rf /tmp/udp2raw/bin/* $KSROOT/bin/
cp -rf /tmp/udp2raw/scripts/* $KSROOT/scripts/
cp -rf /tmp/udp2raw/init.d/* $KSROOT/init.d/
cp -rf /tmp/udp2raw/webs/* $KSROOT/webs/
cp /tmp/udp2raw/uninstall.sh $KSROOT/scripts/uninstall_udp2raw.sh

chmod +x $KSROOT/bin/udp2raw
chmod +x $KSROOT/scripts/udp2raw_*
chmod +x $KSROOT/init.d/S99udp2raw.sh

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/scripts/udp2raw*

dbus set softcenter_module_udp2raw_description=UDP加速神器
dbus set softcenter_module_udp2raw_install=1
dbus set softcenter_module_udp2raw_name=udp2raw
dbus set softcenter_module_udp2raw_title=udp2raw
dbus set softcenter_module_udp2raw_version=0.1

# make udp2raw restart/stop to apply change
sh /koolshare/scripts/udp2raw_config.sh

sleep 1
rm -rf /tmp/udp2raw* >/dev/null 2>&1










