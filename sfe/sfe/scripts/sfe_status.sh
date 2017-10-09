#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

fwlocal=`cat /etc/openwrt_release|grep DISTRIB_RELEASE|cut -d "'" -f 2|cut -d "V" -f 2`
date=`echo_date1`
checkversion=`versioncmp $fwlocal 2.7`

[ "$checkversion" == "1" ] && {
	http_response "<font color='#ff5500'>当前固件版本不支持开启SFE引擎，最低支持版本为2.7！</font>"
	exit 0
}

if [ -d /sys/module/fast_classifier ];then
	http_response "【$date】 SFE快速转发引擎运行正常！"
else
	http_response "<font color='#FF0000'>SFE快速转发引擎未加载</font>"
fi
