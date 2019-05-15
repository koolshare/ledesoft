#!/bin/sh

alias echo_date='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

status=`pidof vpnserver`
date=`echo_date`

if [ -n "$status" ];then
	http_response "【$date】 SoftetherVPN 进程运行正常！&nbsp;&nbsp;(pid: $status)"
else
	http_response "<font color='#FF0000'>SoftetherVPN进程未运行！</font>"
fi