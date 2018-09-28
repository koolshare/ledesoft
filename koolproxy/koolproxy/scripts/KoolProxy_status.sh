#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export koolproxy_`

version=`koolproxy -v`
status=`ps | grep koolproxy | grep -v grep | wc -l`
date=`echo_date1`
pid=`pidof koolproxy`

rules_date_local=`cat $KSROOT/koolproxy/data/rules/koolproxy.txt  | sed -n '3p'|awk '{print $3,$4}'`
rules_nu_local=`grep -E -v "^!" $KSROOT/koolproxy/data/rules/koolproxy.txt | wc -l`

if [ "$status" -ge "1" ]; then
	if [ "$koolproxy_oline_rules" == "1" ]; then
		http_response "【$date】 KoolProxy $version  进程运行正常！(PID: $pid) @@绿坝规则：$rules_date_local / $rules_nu_local条"
	else
		http_response "【$date】 KoolProxy $version  进程运行正常！(PID: $pid) @@<font color='#FF0000'>未加载！</font>"	
	fi		
else
	http_response "<font color='#FF0000'>【警告】：进程未运行！</font> @@<font color='#FF0000'>未加载！</font>"
fi
