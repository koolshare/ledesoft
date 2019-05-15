#!/bin/sh /etc/rc.common
#
# Copyright (C) 2015 OpenWrt-dist
# Copyright (C) 2016 fw867 <ffkykzs@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

START=99
STOP=15

source /koolshare/scripts/base.sh
eval `dbus export iscsi_`

start(){
	[ "$iscsi_enable" == "1" ] && /koolshare/scripts/iscsi_config.sh
}

stop(){
	/koolshare/scripts/iscsi_config.sh
}
