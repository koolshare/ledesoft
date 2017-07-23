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
eval `dbus export ddnsto_`

start(){
	[ "$ddnsto_enable" == "1" ] && ddnsto -u $ddnsto_token -d
}

stop(){
	killall ddnsto
}
