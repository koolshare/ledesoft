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
eval `dbus export memory_`

start(){
	[ "$memory_on_loaded" == "1" ] && /koolshare/scripts/memory_config.sh load
}

stop(){
	/koolshare/scripts/memory_config.sh 2
}
