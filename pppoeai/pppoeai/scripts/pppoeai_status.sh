#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

date=`echo_date1`

if [ -f "/etc/hotplug.d/iface/00-pppoeai" ];then
	http_response "【$date】 拨号助手已开启"
else
	http_response "<font color='#FF0000'>拨号助手未开启！</font>"
fi

