#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

pid=`pidof vlmcsd`
date=`echo_date1`

if [ -n "$pid" ];then
	http_response "【$date】 vlmcsd 进程运行正常！(PID: $pid)"
else
	http_response "<font color='#FF0000'>【警告】：进程未运行！</font>"
fi
