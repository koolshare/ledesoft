#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export fastdick_`

mkdir -p $KSROOT/init.d
mkdir -p $KSROOT/fastdick
cd /tmp
cp -rf /tmp/fastdick/fastdick/* $KSROOT/fastdick/
cp -rf /tmp/fastdick/scripts/* $KSROOT/scripts/
cp -rf /tmp/fastdick/init.d/* $KSROOT/init.d/
cp -rf /tmp/fastdick/webs/* $KSROOT/webs/
cp /tmp/fastdick/uninstall.sh $KSROOT/scripts/uninstall_fastdick.sh

chmod +x $KSROOT/scripts/fastdick_*
chmod +x $KSROOT/init.d/S99fastdick.sh

dbus set softcenter_module_fastdick_description=宽带上下行提速
dbus set softcenter_module_fastdick_install=1
dbus set softcenter_module_fastdick_name=fastdick
dbus set softcenter_module_fastdick_title=迅雷快鸟
dbus set softcenter_module_fastdick_version=0.1

sleep 1
rm -rf /tmp/fastdick* >/dev/null 2>&1
