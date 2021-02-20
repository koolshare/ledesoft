#!/bin/sh /etc/rc.common
#
# Copyright (C) 2015 OpenWrt-dist
# Copyright (C) 2016 fw867 <ffkykzs@gmail.com>
# Copyright (C) 2016 sadog <sadoneli@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

START=88
STOP=15

source /koolshare/scripts/base.sh
eval `dbus export uuacc_`

start(){
	[ "$uuacc_enable" == "1" ] && /bin/sh /koolshare/uu//uuplugin_monitor.sh &
}

stop(){
	uuplugin_monitor=`ps|grep "uuplugin_monitor.sh"|grep -v grep|awk '{print $1}'| xargs kill >/dev/null 2>&1`
	$uuplugin_monitor
	killall uuplugin >/dev/null 2>&1
}
