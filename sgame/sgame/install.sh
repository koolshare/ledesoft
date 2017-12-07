#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export sgame_`

mkdir -p $KSROOT/sgame
cd /tmp
cp -rf /tmp/sgame/bin/* $KSROOT/bin/
cp -rf /tmp/sgame/scripts/* $KSROOT/scripts/
cp -rf /tmp/sgame/webs/* $KSROOT/webs/
cp -rf /tmp/sgame/sgame/* $KSROOT/sgame/
cp -rf /tmp/sgame/hotplug/* /etc/hotplug.d/iface/
cp /tmp/sgame/uninstall.sh $KSROOT/scripts/uninstall_sgame.sh

chmod +x $KSROOT/scripts/sgame_*
chmod +x $KSROOT/sgame/*.sh
chmod +x $KSROOT/bin/shadowvpn
chmod +x $KSROOT/bin/speederv2

dbus set softcenter_module_sgame_description="外服游戏解决方案"
dbus set softcenter_module_sgame_install=1
dbus set softcenter_module_sgame_name=sgame
dbus set softcenter_module_sgame_title="游戏加速器"
dbus set softcenter_module_sgame_version=0.1

sleep 1
rm -rf /tmp/sgame* >/dev/null 2>&1
