#!/bin/sh

alias echo_date='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export fwupdate_`

fwlocal=`cat /etc/openwrt_release|grep DISTRIB_RELEASE|cut -d "'" -f 2|cut -d "V" -f 2`
timenow=`date +%Y%m%d%H%M`
[ ! -f "/tmp/upload/fw_log.txt" ] && touch "/tmp/upload/fw_log.txt"
[ -z "$fwupdate_lastcheck" ] && fwupdate_lastcheck="0"

get_last(){
	rm -rf /tmp/fwversion
	wget --referer=http://koolshare.cn --timeout=8 -qO - http://firmware.koolshare.cn/LEDE_X64_fw867/version.md > /tmp/fwversion
	echo_date "正在为小主自动检测最新固件！" >> /tmp/upload/fw_log.txt
	if [ -s "/tmp/fwversion" ];then
		fwsha256=$(cat /tmp/fwversion | sed -n 2p)
		fwlast=$(cat /tmp/fwversion | sed -n 3p)
		dbus set fwupdate_fwlocal="$fwlocal"
		dbus set fwupdate_fwlast="$fwlast"
		dbus set fwupdate_fwsha256="$fwsha256"
		dbus set fwupdate_lastcheck="$timenow"
	fi
}

if [ "$timenow" -gt "$fwupdate_lastcheck" ];then
	get_last
else
	fwlast=$fwupdate_fwlast
fi

[ -z "$fwlocal" ] && fwlocal="<font color='#FF0000'>本地版本信息获取失败！</font>"
[ -z "$fwlast" ] && fwlast="<font color='#FF0000'>最新版本信息获取失败！</font>"

http_response "$fwlocal @@ $fwlast"
