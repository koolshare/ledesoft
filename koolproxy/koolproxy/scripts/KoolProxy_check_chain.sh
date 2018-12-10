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

KP_NUMBER=`iptables -t nat -L PREROUTING | sed -e '1,2d' | sed -n '/KOOLPROXY/='`

SS_NUMBER=`iptables -t nat -L PREROUTING | sed -e '1,2d' | sed -n '/SHADOWSOCKS/='`
[ -n "$SS_NUMBER" ] && export number="1"

V2_NUMBER=`iptables -t nat -L PREROUTING | sed -e '1,2d' | sed -n '/V2RAY/='`
[ -n "$V2_NUMBER" ] && export number="2"

KG_NUMBER=`iptables -t nat -L PREROUTING | sed -e '1,2d' | sed -n '/KOOLGAME/='`
[ -n "$KG_NUMBER" ] && export number="3"

[ ! "$KP_ENABLE" == "1" ] && return 0 || continue

case $number in
1)
	[ "$KP_NUMBER" -gt "$SS_NUMBER" ] && /koolshare/init.d/S99koolss.sh restart
	;;
2)
	[ "$KP_NUMBER" -gt "$V2_NUMBER" ] && /koolshare/init.d/S99v2ray.sh restart
	;;
3)
	[ "$KP_NUMBER" -gt "$KG_NUMBER" ] && /koolshare/init.d/S98koolgame.sh restart
	;;
esac
