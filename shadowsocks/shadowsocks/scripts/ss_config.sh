#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export ss_`

# this part for start up
case $1 in
start)
	# the soft link should be create after boot
	[ "$ss_basic_enable" == "1" ] && sh /jffs/koolshare/ss/start.sh start_all > /tmp/upload/ss_log.txt
	;;
stop)
	sh /jffs/koolshare/koolproxy/kp_config.sh stop > /tmp/upload/kp_log.txt
	;;
esac

# this part for web runing using httpdb
case $2 in
1)
	if [ "$ss_basic_enable" == "1" ];then
		sh /jffs/koolshare/ss/start.sh start_all $1 > /tmp/upload/ss_log.txt
	else
		sh /jffs/koolshare/ss/start.sh stop > /tmp/upload/kp_log.txt
	fi
	echo XU6J03M6 >> /tmp/upload/ss_log.txt
	http_response $1
	;;
10)
	# do not delete this, it's usefull when saving ss_node data
	http_response "$1"
	;;
esac