#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

status=`pidof uuplugin`
version=`/koolshare/uu/uuplugin -v|grep version:|cut -d ":" -f2`
date=`echo_date1`

if [ -n "$status" ];then
	http_response "【$date】 UU加速器 $version 运行正常！&nbsp;&nbsp;(pid: $status)"
else
	http_response "<font color='#FF0000'>UU加速器未运行！</font>"
fi

