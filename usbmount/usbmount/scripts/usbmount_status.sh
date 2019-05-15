#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

date=`echo_date1`

if [ -L "/etc/hotplug.d/block/20-usbmount" ];then
	http_response "【$date】 USB自动挂载已开启"
else
	http_response "<font color='#FF0000'>USB自动挂载未开启！</font>"
fi

