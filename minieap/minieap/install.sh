#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export minieap_`

mkdir -p $KSROOT/init.d
cd /tmp
cp -rf /tmp/minieap/bin/* $KSROOT/bin/
cp -rf /tmp/minieap/scripts/* $KSROOT/scripts/
cp -rf /tmp/minieap/init.d/* $KSROOT/init.d/
cp -rf /tmp/minieap/webs/* $KSROOT/webs/
cp /tmp/minieap/uninstall.sh $KSROOT/scripts/uninstall_minieap.sh

chmod +x $KSROOT/bin/minieap
chmod +x $KSROOT/scripts/minieap_*
chmod +x $KSROOT/init.d/S99minieap.sh

dbus set softcenter_module_minieap_description=锐捷等802.1x认证客户端
dbus set softcenter_module_minieap_install=1
dbus set softcenter_module_minieap_name=minieap
dbus set softcenter_module_minieap_title=校园认证
dbus set softcenter_module_minieap_version=0.1

sleep 1
rm -rf /tmp/minieap* >/dev/null 2>&1
