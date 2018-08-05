#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

runstatus=`tail -n 1 $KSROOT/smzdm/log`

if [ -n "$runstatus" ];then
	http_response "$runstatus"
else
	http_response "<font color='#FF0000'>【警告】：自动签到还没有运行！</font>"
fi

