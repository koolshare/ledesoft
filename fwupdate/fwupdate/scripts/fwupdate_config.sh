#!/bin/sh

alias echo_date='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export fwupdate_`
logfile="/tmp/upload/fw_log.txt"
fwserver="http://firmware.koolshare.cn/LEDE_X64_fw867"
fwlocal=`cat /etc/openwrt_release|grep DISTRIB_RELEASE|cut -d "'" -f 2|cut -d "V" -f 2`

echo "" >> $logfile
sleep 1

get_keep_mode(){
	case "$1" in
		0)
			echo "-n"
		;;
		1)
			echo ""
		;;
	esac
}

get_keep_status(){
	case "$1" in
		0)
			echo_date "将为你清除所有配置，恢复为出厂配置！" >> $logfile
		;;
		1)
			echo_date "你选择了保留配置，升级后保留所有配置！" >> $logfile
		;;
	esac
}


update_firmware(){
	/sbin/sysupgrade $(get_keep_mode $fwupdate_keep) /tmp/$fwfile
}

download_firmware(){
	wget --referer=http://koolshare.cn --timeout=8 -O - $fwserver/$fwfile > /tmp/$fwfile
	echo_date "固件下载完成，开始校验固件" >> $logfile
	dlsha256=`sha256sum /tmp/$fwfile|awk '{print $1}'`
	echo_date "原始文件校验码：$fwsha256" >> $logfile
	echo_date "下载文件校验码：$dlsha256" >> $logfile
	echo_date "============================================" >> $logfile
	if [ "$fwsha256" == "$dlsha256" ];then
		echo_date "下载完成，校验通过，开始升级固件，升级完成后自动重启！" >> $logfile
		get_keep_status $fwupdate_keep
		update_firmware
	else
		echo_date "下载完成，但是校验没有通过！" >> $logfile
	fi
}

get_update(){
	echo_date "============================================" >> $logfile
	echo_date "开始检测最新固件版本" >> $logfile
	rm -rf /tmp/fwversion
	wget --referer=http://koolshare.cn --timeout=8 -qO - $fwserver/version.md > /tmp/fwversion
	if [ -s "/tmp/fwversion" ];then
		fwfile=$(cat /tmp/fwversion | sed -n 1p)
		fwsha256=$(cat /tmp/fwversion | sed -n 2p)
		fwlast=$(cat /tmp/fwversion | sed -n 3p)
		echo_date "本地固件版本为：$fwlast" >> $logfile
		echo_date "最新固件版本为：$fwlast" >> $logfile
		echo_date "============================================" >> $logfile
		if [ "$fwlocal" != "$fwlast" ];then
			echo_date "检测到有新固件，开始下载固件..." >> $logfile
			download_firmware
		else
			if [ "$fwupdate_enforce" == "1" ];then
				echo_date "当前已经是最新固件，但你选择了强制刷新，将为你下载固件..." >> $logfile
				download_firmware
			else
				echo_date "真棒，你已经升级到最新固件了，无需更新！" >> $logfile
				echo_date "enforce $fwupdate_enforce" >> $logfile
			fi
		fi
			
	else
		echo_date "获取最新固件版本号失败，请检查网络或稍后再试！" >> $logfile	
	fi
}



case $2 in
*)
	rm -rf $logfile
	get_update
	echo XU6J03M6 >> $logfile
	http_response "$1"
	;;
restart)
	rm -rf $logfile
	get_update
	echo XU6J03M6 >> $logfile
	http_response "$1"
	;;
esac