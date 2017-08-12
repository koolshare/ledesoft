#!/bin/sh
alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export softether_`

# this part for start up
case $1 in
start)
	# the soft link should be create after boot
	[ "$softether_enable" == "1" ] && sh $KSROOT/softether/softether.sh restart
	;;
stop)
	sh $KSROOT/softether/softether.sh stop 
	;;
esac

# this part for web runing using httpdb
case $2 in
1)
	if [ "$softether_enable" == "1" ];then
		sh $KSROOT/softether/softether.sh restart > /tmp/upload/softether_log.txt
	else
		sh $KSROOT/softether/softether.sh stop > /tmp/upload/softether_log.txt
	fi
	echo XU6J03M6 >> /tmp/upload/softether_log.txt
	http_response $1
	;;
esac