#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export sgame_`

mkdir -p $KSROOT/sgame
cp -rf /tmp/sgame/bin/* $KSROOT/bin/
cp -rf /tmp/sgame/sgame/* $KSROOT/sgame/
cp -rf /tmp/sgame/init.d/* $KSROOT/init.d/
cp -rf /tmp/sgame/scripts/* $KSROOT/scripts/
cp -rf /tmp/sgame/webs/* $KSROOT/webs/
cp /tmp/sgame/uninstall.sh $KSROOT/scripts/uninstall_sgame.sh

chmod +x $KSROOT/scripts/sgame_*
chmod +x $KSROOT/bin/tinyvpn
chmod +x $KSROOT/bin/udp2raw
chmod +x $KSROOT/bin/smartdns
chmod +x $KSROOT/bin/tinymapper

[ -n "$sgame_base_cron" ] && {
	dbus remove sgame_base_cron
	dbus remove sgame_base_cron_disablehour
	dbus remove sgame_base_cron_disableminute
	dbus remove sgame_base_cron_enablehour
	dbus remove sgame_base_cron_enableminute
	dbus remove sgame_enable
	dbus set sgame_acl_node_max=0
	dbus set sgame_tiynmapper_node_max=`dbus list sgame_tiynmapper_port_|wc -l`
}

[ -z "$sgame_acl_node_max" ] && dbus set sgame_acl_node_max=0
[ -z "$sgame_tiynmapper_node_max" ] && dbus set sgame_tiynmapper_node_max=0

dbus set softcenter_module_sgame_description="外服游戏解决方案"
dbus set softcenter_module_sgame_install=1
dbus set softcenter_module_sgame_name=sgame
dbus set softcenter_module_sgame_title="游戏加速器"
dbus set softcenter_module_sgame_version=0.1

sleep 1
rm -rf /tmp/sgame* >/dev/null 2>&1
