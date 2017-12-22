#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

status=`pidof easyexplorer`
version=`easyexplorer -v`
date=`echo_date1`


if [ -n "$status" ];then
	if  [ -f "/usr/bin/video_mux" ]; then
		dlnamoudle="DLNA解码组件安装正常"
	else
		dlnamoudle="DLNA解码组件未安装"
	fi
	http_response "【$date】 EasyExplorer进程运行正常，$dlnamoudle！&nbsp;&nbsp;($version)"
else
	http_response "<font color='#FF0000'>EasyExplorer进程未运行！</font>"
fi
