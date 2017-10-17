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
eval `dbus export aria2_`

boot(){
	[ "$aria2_enable" == "1" ] && {
		sleep $aria2_sleep
		/koolshare/scripts/aria2_config.sh
	}
}

start(){
	[ "$aria2_enable" == "1" ] && sh /koolshare/scripts/aria2_config.sh
}

stop(){
	sh /koolshare/scripts/aria2_config.sh
}
