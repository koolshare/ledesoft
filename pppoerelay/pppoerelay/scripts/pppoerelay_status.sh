#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

status=`pidof pppoe-relay`
date=`echo_date1`

if [ -n "$status" ];then
	http_response "【$date】 PPPoE穿透运行正常！&nbsp;&nbsp;(pid: $status)"
else
	http_response "<font color='#FF0000'>【警告】PPPoE穿透未运行！</font>"
fi
