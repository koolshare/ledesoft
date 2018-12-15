#!/bin/sh
#
# Copyright (C) 2015 OpenWrt-dist
# Copyright (C) 2018 houzi- <wojiaolinmu008@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
source $KSROOT/bin/helper.sh

KP_ENABLE=`dbus get koolproxy_enable`
SS_ENABLE=`dbus get ss_basic_enable`
V2_ENABLE=`dbus get v2ray_basic_enable`
KG_ENABLE=`dbus get koolgame_basic_enable`

KP_NUMBER=`iptables -t nat -L PREROUTING | sed -e '1,2d' | sed -n '/KOOLPROXY/=' | sed -n '1p'`

SS_DUPLICATE=`iptables -t nat -L PREROUTING | sed -e '1,2d' | grep SHADOWSOCKS | wc -l`
SS_NUMBER=`iptables -t nat -L PREROUTING | sed -e '1,2d' | sed -n '/SHADOWSOCKS/=' | sed -n '1p'`
[ "$SS_ENABLE" == "1" ] && export number="1"

V2_DUPLICATE=`iptables -t nat -L PREROUTING | sed -e '1,2d' | grep V2RAY | wc -l`
V2_NUMBER=`iptables -t nat -L PREROUTING | sed -e '1,2d' | sed -n '/V2RAY/=' | sed -n '1p'`
[ "$V2_ENABLE" == "1"  ] && export number="2"

KG_DUPLICATE=`iptables -t nat -L PREROUTING | sed -e '1,2d' | grep KOOLGAME | wc -l`
KG_NUMBER=`iptables -t nat -L PREROUTING | sed -e '1,2d' | sed -n '/KOOLGAME/=' | sed -n '1p'`
[ "$KG_ENABLE" == "1" ] && export number="3"

[ ! "$KP_ENABLE" == "1" ] && return 0 || continue

case $number in
1)
	[ "$KP_NUMBER" -gt "$SS_NUMBER" -o "$SS_DUPLICATE" -ge "2" ] && /koolshare/init.d/S99koolss.sh restart
	;;
2)
	[ "$KP_NUMBER" -gt "$V2_NUMBER" -o "$V2_DUPLICATE" -ge "2" ] && /koolshare/init.d/S99v2ray.sh restart
	;;
3)
	[ "$KP_NUMBER" -gt "$KG_NUMBER" -o "$KG_DUPLICATE" -ge "2" ] && /koolshare/init.d/S98koolgame.sh restart
	;;
esac
