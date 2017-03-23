#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
eval `dbus export swap_`

makekswap(){
	[ "$swap_on_size" == "1" ] && size=262148
	[ "$swap_on_size" == "2" ] && size=524292
	[ "$swap_on_size" == "3" ] && size=1024004
	if [ ! -f "$swap_disk"/tt_swapfile ];then
		cd "$swap_disk"
		echo_date "创建swap需要较长的时间，请耐心等待..."
		dd if=/dev/zero of="$swap_disk"/tt_swapfile bs=1024 count="$size"
		echo_date "创建完毕，挂载swap..."
		mkswap tt_swapfile
		chmod 600 tt_swapfile
		swapon tt_swapfile
		echo_date "挂载swap成功..."
	fi
}

case $1 in
load)
	logger [ttsoft] start swap...
	sfile=`mount | grep "$swap_disk"`
	i=60
	until [ -n "$sfile" ]
	do
	    i=$(($i-1))
	    if [ "$i" -lt 1 ];then
			logger [ttsoft] can not find swapfile...
	        exit
	    fi
	    sleep 1
	done
	if [ -f "$swap_disk/tt_swapfile" ];then
		if [ `free | grep Swap|awk '{print $2}'` == "0" ];then
			logger [ttsoft] mounting swap...
			swapon "$swap_disk/tt_swapfile"
			nvram set script_usbmount="sh /jffs/koolshare/scripts/swap_config.sh load"
			nvram commit
		else
			logger [ttsoft] already mounted
		fi
	else
		logger [ttsoft] no swap file found!
	fi
	;;
esac

case $2 in
1)
	echo_date "你选择了磁盘$swap_disk，开始创建虚拟内存..." > /tmp/upload/swap_log.txt
	makekswap >> /tmp/upload/swap_log.txt
	echo XU6J03M6 >> /tmp/upload/swap_log.txt
	http_response "$1"
	nvram set script_usbmount="/jffs/koolshare/scripts/swap_config.sh load"
	nvram commit
	;;
2)
	echo_date "准备删除swap..." > /tmp/upload/swap_log.txt
	echo_date "寻找swap文件..." >> /tmp/upload/swap_log.txt
	if [ ! -f  "$swap_disk"/tt_swapfile ];then
		swapfile_dir=`find /tmp/mnt -name "tt_swapfile"`
	else
		swapfile_dir="$swap_disk"/tt_swapfile
	fi
	
	if [ -f "$swapfile_dir" ];then
		echo_date "找到swap文件$swapfile_dir..." >> /tmp/upload/swap_log.txt
		echo_date "卸载swap..." >> /tmp/upload/swap_log.txt
		swapoff "$swapfile_dir"
		echo_date "删除swap..." >> /tmp/upload/swap_log.txt
		rm -rf "$swapfile_dir"
		echo_date "删除swap成功！" >> /tmp/upload/swap_log.txt
		dbus set swap_on_loaded=0
		http_response "$1"
	else
		echo_date "我擦，并没有找到swap文件，退出！" >> /tmp/upload/swap_log.txt
		http_response "$1"
	fi
	mvram unset script_usbmount
	nvram commit
	;;
esac







