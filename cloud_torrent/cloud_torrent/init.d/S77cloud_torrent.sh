#!/bin/sh /etc/rc.common
#
# Copyright (C) 2015 OpenWrt-dist
# Copyright (C) 2016 fw867 <ffkykzs@gmail.com>
# Copyright (C) 2016 sadog <sadoneli@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

START=77
STOP=15

source /koolshare/scripts/base.sh
eval `dbus export cloud_torrent_`

start(){
	if [ "$cloud_torrent_enable" == "1" ];then
		logger "[软件中心]: 启动cloud_torrent"
		sh /koolshare/scripts/cloud_torrent_config.sh start
	fi
}

stop(){
	sh /koolshare/scripts/cloud_torrent_config.sh stop
}

