#!/bin/sh /etc/rc.common
#
# Copyright (C) 2015 OpenWrt-dist
# Copyright (C) 2016 fw867 <ffkykzs@gmail.com>
# Copyright (C) 2016 sadog <sadoneli@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

START=90
STOP=15

source /koolshare/scripts/base.sh
eval `dbus export virtual_`

start(){
	[ "$virtual_enable" == "1" ] && /koolshare/scripts/virtual_config.sh
}

stop(){
	if [ -n "`pidof qemu-ga`" ]; then 
		killall qemu-ga
	fi
	if [ -n "`pidof vmtoolsd`" ];then
		killall vmtoolsd
	fi
}
