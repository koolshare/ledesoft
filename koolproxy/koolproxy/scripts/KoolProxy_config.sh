#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export koolproxy_`

echo "" > /tmp/upload/kp_log.txt
sleep 1
case $2 in
restart)
	if [ "$koolproxy_enable" == "1" ];then
		sh /koolshare/koolproxy/kp_config.sh restart >> /tmp/upload/kp_log.txt 2>&1
	else
		sh /koolshare/koolproxy/kp_config.sh stop >> /tmp/upload/kp_log.txt 2>&1
	fi
	echo XU6J03M6 >> /tmp/upload/kp_log.txt
	http_response "$1"
	;;
esac