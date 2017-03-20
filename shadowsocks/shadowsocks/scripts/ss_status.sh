#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export ss_`
LOGTIME=$(date "+%Y-%m-%d %H:%M:%S")

# version=`koolproxy -v`
# status=`ps|grep -w koolproxy | grep -cv grep`
date=`echo_date1`
# if [ "$status" == "2" ];then
# 	http_response "【$date】 KoolProxy $version  进程运行正常！"
# else
# 	http_response "【警告】：进程未运行！"
# fi
get_china_status(){
	wget -4 --spider --quiet --tries=2 --timeout=2 www.baidu.com
	if [ "$?" == "0" ]; then
		log2='国内链接 【'$LOGTIME'】 working...'
	else
		log2='国内链接 【'$LOGTIME'】 Problem detected!'
	fi
}

get_foreign_status(){
	wget -4 --spider --quiet --tries=2 --timeout=2 www.google.com.tw
	if [ "$?" == "0" ]; then
		log1='国外链接 【'$LOGTIME'】 working...'
	else
		log1='国外链接 【'$LOGTIME'】 Problem detected!'
	fi
}

#for "1" in "1"
#do
#{
#get_china_status
#get_foreign_status
#}&
#done


get_china_status
get_foreign_status

http_response "$log1@@$log2"


