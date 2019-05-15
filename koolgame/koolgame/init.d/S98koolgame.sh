#!/bin/sh /etc/rc.common
#
# Copyright (C) 2015 OpenWrt-dist
# Copyright (C) 2016 fw867 <ffkykzs@gmail.com>
# Copyright (C) 2016 sadog <sadoneli@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

START=98
STOP=15

source /koolshare/scripts/base.sh
eval `dbus export koolgame`

start(){
	[ "$koolgame_basic_enable" == "1" ] && sh /koolshare/scripts/koolgame_config.sh start > /tmp/upload/koolgame_log.txt
}

stop(){
	sh /koolshare/ss/ssstart.sh stop > /tmp/upload/koolgame_log.txt
}
