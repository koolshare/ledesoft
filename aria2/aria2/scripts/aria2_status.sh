#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export aria2`

status=`pidof aria2c`
version=`$KSROOT/aria2/aria2c --version|grep "aria2 version"|cut -d" " -f3`
date=`echo_date1`

generate_token(){
	if [ -z $aria2_rpc_secret ];then
		local token=$(head -200 /dev/urandom | md5sum | cut -d " " -f 1)
		dbus set aria2_rpc_secret="$token"
	fi
}

generate_token

if [ -n "$status" ];then
	http_response "【$date】 Aria2 $version 进程运行正常！&nbsp;&nbsp;(pid: $status)"
else
	http_response "<font color='#FF0000'>Aria2进程未运行！</font>"
fi