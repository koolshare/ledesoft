#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

status=`iptables -t nat -L|grep DMZ`
date=`echo_date1`

if [ -n "$status" ];then
	http_response "【$date】 DMZ 正在运行"
else
	http_response "<font color='#FF0000'>DMZ未运行！</font>"
fi

