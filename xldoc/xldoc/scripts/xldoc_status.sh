#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

status1=`cat /etc/hosts|grep -v grep|grep sandai.net`
status2=`cat /etc/hosts|grep -v grep|grep xunlei.com`
date=`echo_date1`

if [ -n "$status1" -o -n "$status" ];then
	http_response "【$date】 迅雷下载已经修复，你可以正常下载了！"
else
	http_response "<font color='#FF0000'>未开启迅雷下载修复，你可能无法愉快的使用迅雷下载！</font>"
fi

