#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
LOGfile=/tmp/upload/memory_log.txt
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
eval `dbus export memory_`

makekmemory(){
	size=`expr $memory_on_size \* 1024004`
	if [ ! -f "$memory_on_disk"/swap_memoryfile ];then
		cd "$memory_on_disk"
		echo_date "创建虚拟内存需要较长的时间，请耐心等待..."
		dd if=/dev/zero of="$memory_on_disk"/swap_memoryfile bs=1024 count="$size" >/dev/null 2>&1
		sleep 1
		echo_date "创建完毕，挂载虚拟内存..."
		mkswap swap_memoryfile
		chmod 600 swap_memoryfile
		sleep 1
		swapon swap_memoryfile
		echo_date "挂载虚拟内存成功..."
		echo_date "如果页面没有自动刷新，请手动刷新！"
	fi
}

creat_start_up(){
	[ ! -L "/etc/rc.d/S98memory.sh" ] && ln -sf /koolshare/init.d/S98memory.sh /etc/rc.d/S98memory.sh
}

case $1 in
free)
	sync && echo 3 > /proc/sys/vm/drop_caches	
	;;
load)
	sfile=`mount | grep "$memory_disk"`
	i=60
	until [ -n "$sfile" ]
	do
		i=$(($i-1))
		if [ "$i" -lt 1 ];then
			exit
		fi
	sleep 1
	done
	if [ -f "$memory_on_disk/swap_memoryfile" ];then
		[ `free | grep Swap|awk '{print $2}'` == "0" ] && swapon "$memory_on_disk/swap_memoryfile"
	fi
	;;
esac

case $2 in
1)
	echo_date "你选择了磁盘$memory_on_disk，开始创建虚拟内存..." > $LOGfile
	makekmemory >> $LOGfile
	http_response "$1"
	creat_start_up
	sleep 2
	echo XU6J03M6 >> $LOGfile
	;;
2)
	echo_date "准备删除虚拟内存..." > $LOGfile
	echo_date "寻找已创建的虚拟内存文件..." >> $LOGfile
	if [ ! -f  "$memory_on_disk"/swap_memoryfile ];then
		memoryfile_dir=`find /mnt -name "swap_memoryfile"`
	else
		memoryfile_dir="$memory_on_disk"/swap_memoryfile
	fi
	
	if [ -f "$memoryfile_dir" ];then
		echo_date "找到已创建的虚拟内存文件$memoryfile_dir..." >> $LOGfile
		echo_date "卸载已创建的虚拟内存..." >> $LOGfile
		swapoff "$memoryfile_dir"
		echo_date "删除已创建的虚拟内存文件..." >> $LOGfile
		rm -rf "$memoryfile_dir"
		echo_date "删除已创建的虚拟内存成功！" >> $LOGfile
		dbus set memory_on_loaded=0
		sleep 2
		http_response "$1"
	else
		echo_date "我擦，并没有找到已创建的虚拟内存文件，退出！" >> $LOGfile
		sleep 2
		http_response "$1"
	fi
	;;
3)
	if [ "$memory_on_time" == "0" ];then
		echo_date "你已设置关闭自动清理内存" > $LOGfile
		sed -i '/memory_config/d' /etc/crontabs/root >/dev/null 2>&1
		echo_date "已成功关闭自动清理内存" >> $LOGfile
		sleep 2
		http_response "$1"
	else
		echo_date "你已设置开启自动清理内存" > $LOGfile
		sed -i '/memory_config/d' /etc/crontabs/root >/dev/null 2>&1
		echo "*/$memory_on_time * * * * $KSROOT/scripts/memory_config.sh free" >> /etc/crontabs/root
		/etc/init.d/cron start >/dev/null 2>&1
		echo_date "已成功设置每$memory_on_time分钟自动清理内存" >> $LOGfile
		sleep 2
		http_response "$1"
	fi
	;;
esac
