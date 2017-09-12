#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export ss_`
echo "" > /tmp/upload/ss_log.txt



case $2 in
1)
	if [ "$ss_basic_enable" == "1" ];then
		sh /koolshare/ss/ssstart.sh restart >> /tmp/upload/ss_log.txt
	else
		sh /koolshare/ss/ssstart.sh stop >> /tmp/upload/ss_log.txt
	fi
	echo XU6J03M6 >> /tmp/upload/ss_log.txt
	http_response $1
	;;
2)
	# 负载均衡保存
	#sh /koolshare/ss/ssstart.sh lb_restart >> /tmp/upload/ss_log.txt
	http_response $1
	;;
2)
	#sh /koolshare/ss/ssstart.sh lb_restart >> /tmp/upload/ss_log.txt
	http_response $1
	;;
esac