#!/bin/sh /etc/rc.common
#
# Copyright (C) 2015 OpenWrt-dist
# Copyright (C) 2016 fw867 <ffkykzs@gmail.com>
# Copyright (C) 2016 sadog <sadoneli@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

START=18
STOP=15

source /koolshare/scripts/base.sh
eval `dbus export pppoeai_` 

boot(){
	until ip route show 0/0 | grep -q "^default"; do
		sleep 1
	done	
	start
}

start(){
	[ "$pppoeai_enable" == "1" ] && sh /koolshare/scripts/pppoeai_config.sh
}

stop(){
	sh /koolshare/scripts/pppoeai_config.sh
}
