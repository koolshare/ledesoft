#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export ss_`
date=`echo_date1`
LOGTIME=$(date "+%Y-%m-%d %H:%M:%S")


get_china_status(){
	wget -4 --spider --quiet --tries=2 --timeout=2 www.baidu.com
	if [ "$?" == "0" ]; then
		log2='国内链接 【'$LOGTIME'】 ✓'
	else
		log2='国内链接 【'$LOGTIME'】 <font color='#FF0000'>X</font>'
	fi
}

get_foreign_status(){
	wget -4 --spider --quiet --tries=2 --timeout=2 www.google.com.tw
	if [ "$?" == "0" ]; then
		log1='国外链接 【'$LOGTIME'】 ✓'
	else
		log1='国外链接 【'$LOGTIME'】 <font color='#FF0000'>X</font>'
	fi
}

get_kcp_status(){
	if [ -n "`pidof kcpclient`" ]; then
		log3='KCP加速 【'$LOGTIME'】 ✓'
	else
		log3='KCP加速 【'$LOGTIME'】 <font color='#FF0000'>X</font>'
	fi
}

get_lb_status(){
	if [ -n "`pidof haproxy`" ]; then
		log4='负载均衡 【'$LOGTIME'】 ✓'
	else
		log4='负载均衡 【'$LOGTIME'】 <font color='#FF0000'>X</font>'
	fi
}


get_china_status
get_foreign_status
[ "$ss_kcp_enable" == "1" ] && [ "$ss_kcp_node" == "$ss_basic_node" ] && get_kcp_status
[ "$ss_basic_node" == "0" ] && [ -n "$ss_lb_node_max" ] && get_lb_status

http_response "$log1@@$log2@@$log3@@$log4"
