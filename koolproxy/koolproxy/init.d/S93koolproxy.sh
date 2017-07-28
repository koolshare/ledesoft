#!/bin/sh /etc/rc.common
#
# Copyright (C) 2015 OpenWrt-dist
# Copyright (C) 2016 fw867 <ffkykzs@gmail.com>
# Copyright (C) 2016 sadog <sadoneli@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

START=93
STOP=15

source /koolshare/scripts/base.sh
eval `dbus export koolproxy_`


start(){
	[ ! -L "/tmp/upload/user.txt" ] && ln -sf $KSROOT/koolproxy/data/user.txt /tmp/upload/user.txt
	[ "$koolproxy_enable" == "1" ] && sh /koolshare/koolproxy/kp_config.sh restart >> /tmp/upload/kp_log.txt
}

stop(){
	sh /koolshare/koolproxy/kp_config.sh stop >> /tmp/upload/kp_log.txt
}