#!/bin/sh /etc/rc.common
#
# Copyright (C) 2015 OpenWrt-dist
# Copyright (C) 2016 fw867 <ffkykzs@gmail.com>
# Copyright (C) 2016 sadog <sadoneli@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

START=99
STOP=15

source /koolshare/scripts/base.sh
eval `dbus export webd_`

start(){
	if [ "$webd_enable" == "1" ];then
		/koolshare/scripts/webd_config.sh
	fi
}

stop(){
	/koolshare/scripts/webd_config.sh stop
}

