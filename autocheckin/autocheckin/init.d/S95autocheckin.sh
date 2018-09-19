#!/bin/sh /etc/rc.common
#
# Copyright (C) 2015 OpenWrt-dist
# Copyright (C) 2016 fw867 <ffkykzs@gmail.com>
# Hack for houzi- <wojiaolinmu008@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

START=95
STOP=15

source /koolshare/scripts/base.sh
eval `dbus export autocheckin_`

start(){
	[ "$autocheckin_enable" == "1" ] && /koolshare/scripts/autocheckin_config.sh
}

stop(){
	/koolshare/scripts/autocheckin_config.sh
}
