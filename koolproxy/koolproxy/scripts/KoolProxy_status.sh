#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export koolproxy_`

version=`koolproxy -v`
status=`ps|grep -w koolproxy | grep -cv grep`
date=`echo_date1`
if [ "$status" == "2" ];then
	http_response "【$date】 KoolProxy $version  进程运行正常！"
else
	http_response "【警告】：进程未运行！"
fi

