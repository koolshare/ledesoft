#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

status=`pidof baidupcs`
version=`baidupcs -v`
date=`echo_date1`


if [ -n "$status" ];then
	http_response "【$date】 百度网盘进程运行正常！&nbsp;&nbsp;($version)"
else
	http_response "<font color='#FF0000'>百度网盘进程未运行！</font>"
fi
