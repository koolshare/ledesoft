#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export sgame_`
date=`echo_date1`
LOGTIME=$(date "+%Y-%m-%d %H:%M:%S")


get_ssvpn_status(){
	local svpnstatus udpstatus
	svpnstatus=`pidof tinyvpn`
	udpstatus=`pidof udp2raw`
	[ -n "$udpstatus" ] && log4="  Udp2raw 【$LOGTIME】 ✓"
	if [ -n "$svpnstatus" ]; then
		log3='TinyVPN 【'$LOGTIME'】 ✓  '$log4''
	else
		log3='<font color='#FF0000'>没有运行 【'$LOGTIME'】 X</font>'
	fi
}

get_china_status(){
	wget -4 --spider --quiet --tries=2 --timeout=2 www.baidu.com
	if [ "$?" == "0" ]; then
		log2='国内链接 【'$LOGTIME'】 ✓'
	else
		log2='<font color='#FF0000'>国内链接 【'$LOGTIME'】 X</font>'
	fi
}

get_foreign_status(){
	wget -4 --spider --quiet --tries=2 --timeout=2 www.google.com
	if [ "$?" == "0" ]; then
		log1='国外链接 【'$LOGTIME'】 ✓'
	else
		log1='<font color='#FF0000'>国外链接 【'$LOGTIME'】 X</font>'
	fi
}

get_ssvpn_status
get_china_status
get_foreign_status

http_response "$log3@@$log1@@$log2"
