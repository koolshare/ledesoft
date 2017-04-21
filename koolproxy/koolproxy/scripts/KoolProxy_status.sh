#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export koolproxy_`

version=`koolproxy -v`
status=`ps|grep -w koolproxy | grep -cv grep`
date=`echo_date1`

rules_date_local=`cat $KSROOT/koolproxy/data/rules/koolproxy.txt  | sed -n '3p'|awk '{print $3,$4}'`
rules_nu_local=`grep -E -v "^!" $KSROOT/koolproxy/data/rules/koolproxy.txt | wc -l`
video_date_local=`cat $KSROOT/koolproxy/data/rules/koolproxy.txt  | sed -n '4p'|awk '{print $3,$4}'`

if [ "$status" == "2" ];then
	http_response "【$date】 KoolProxy $version  进程运行正常！@@静态规则：$rules_date_local / $rules_nu_local条&nbsp;&nbsp;&nbsp;&nbsp;视频规则：$video_date_local"
else
	http_response "【警告】：进程未运行！"
fi

