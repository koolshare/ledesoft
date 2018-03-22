#!/bin/sh /etc/rc.common
#
# Copyright (C) 2015 OpenWrt-dist
# Copyright (C) 2016 fw867 <ffkykzs@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

START=98
STOP=15

source /koolshare/scripts/base.sh
eval `dbus export v2ray_`


start(){
	[ "$v2ray_enable" == "1" ] && /koolshare/scripts/v2ray_config.sh restart
}

stop(){
	/koolshare/scritps/v2ray_config.sh stop
}