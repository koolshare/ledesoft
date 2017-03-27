#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export swap`

write_disk_info(){
	# 删除所有磁盘信息
	disk_values=`dbus list swap_disk_|cut -d "=" -f1`
	for value in $disk_values
	do
		dbus remove $value
	done
	# 这里独立出来，循环写入，保证web获得的列表是最新的
	disk_info=`df -Th |grep "/dev/sd"`
	if [ -n "$disk_info" ];then
		# 获取到了磁盘信息，写入dbus，为了防止频繁写入带来问题，采用ram写入
		disk_nu=`echo "$disk_info" | wc -l`
		dbus set swap_disk_nu="$disk_nu"
		i=1
		while [ ${i} -le $disk_nu ]
		do
			dbus set swap_disk_name_"$i"=`echo "$disk_info" | sed -n "$i"\p |awk '{print $1}'`
			dbus set swap_disk_type_"$i"=`echo "$disk_info" | sed -n "$i"\p |awk '{print $2}'`
			dbus set swap_disk_size_"$i"=`echo "$disk_info" | sed -n "$i"\p |awk '{print $3}'`
			dbus set swap_disk_used_"$i"=`echo "$disk_info" | sed -n "$i"\p |awk '{print $4}'`
			dbus set swap_disk_aval_"$i"=`echo "$disk_info" | sed -n "$i"\p |awk '{print $5}'`
			dbus set swap_disk_useP_"$i"=`echo "$disk_info" | sed -n "$i"\p |awk '{print $6}'`
			dbus set swap_disk_moon_"$i"=`echo "$disk_info" | sed -n "$i"\p |awk '{print $7}'`
		    i=`expr $i + 1`
		done
		ext_nu=`echo "$disk_info"|grep ext |wc -l`
		dbus set swap_ext_nu="$ext_nu"
	fi
}

write_disk_info

# 检测是否已经挂载了虚拟内存
swapon2=`free | grep Swap|awk '{print $2}'`
if [ "$swapon2" == "0" ];then
	# 没有挂载
	# skipd值没了，但是swap还在
	if [ -z "$swap_on_disk" ];then
		swapfile_dir=`find /tmp/mnt -name "tt_swapfile"`
		if [ -n "$swapfile_dir" ];then
			swapon $swapfile_dir
			sleep 2
			swapused=`free | grep Swap|awk '{print $3}'`
			swap_mount_size=`awk 'BEGIN{printf "%0.2f",'$swapon2'/1024}'`
			swap_used_size=`awk 'BEGIN{printf "%0.2f",'$swapused'/1024}'`
			dbus set swap_on_loaded=1
			dbus set swap swap_on_disk=`find /tmp/mnt -name "tt_swapfile"|cut -d "/" -f1,2,3,4`
			http_response "成功挂载了虚拟内存！</br>大小：$swap_mount_size MB &nbsp;&nbsp;&nbsp; 已使用：$swap_used_size MB"
		else
			# 检测到没有swap，那么获取下磁盘信息
			disk_info=`df -Th |grep "/dev/sd"`
			if [ ! -z "$disk_info" ];then
				if [ "$ext_nu" != "0" ];then
					http_response "共找到$disk_nu个磁盘,</br>其中有$ext_nu个ext格式的磁盘符合要求。" 
					dbus set swap_on_loaded=0
				else
					http_response "共找到$disk_nu个磁盘,</br>然而并没有磁盘符合创建虚拟内存的要求"
					dbus set swap_on_loaded=3
				fi
			else
				http_response "没有找到可用磁盘！"
				dbus set swap_on_loaded=2
			fi
		fi
	else
		# skipd值有，swap在
		if [ -f "$swap_on_disk"/tt_swapfile ];then
			# 没有挂载但是检测到有swap文件
			swapon "$swap_on_disk"/tt_swapfile
			sleep 2
			swapon3=`free | grep Swap|awk '{print $2}'`
			if [ "$swapon3" != "0" ];then
				# 检测到有，但是没有挂在，帮忙挂载
				http_response "检测到你已有的swap文件，但是没有挂载，已经为你挂载！请刷新本页面！"
				dbus set swap_on_loaded=1
			else
				# 检测到有，但是挂载失败，帮忙删除
				http_response "检测到你已有的swap文件，但是尝试挂在失败！"
				dbus set swap_on_loaded=0
			fi
		else
			# 检测到没有swap，那么获取下磁盘信息
			disk_info=`df -Th |grep "/dev/sd"`
			if [ ! -z "$disk_info" ];then
				if [ "$ext_nu" != "0" ];then
					http_response "共找到$disk_nu个磁盘,</br>其中有$ext_nu个ext格式的磁盘符合要求。" 
					dbus set swap_on_loaded=0
				else
					http_response "共找到$disk_nu个磁盘,</br>然而并没有磁盘符合创建虚拟内存的要求"
					dbus set swap_on_loaded=3
				fi
			else
				http_response "没有找到可用磁盘！"
				dbus set swap_on_loaded=2
			fi
		fi
	fi
else
	# 检测到挂载了，那么获取下挂载信息
	#swapfile_dir=`find /tmp/mnt -name "tt_swapfile"`
	#swapfile_name=`echo "$swapfile_dir"|cut -d "/" -f5`
	swapused=`free | grep Swap|awk '{print $3}'`
	swap_mount_size=`awk 'BEGIN{printf "%0.2f",'$swapon2'/1024}'`
	swap_used_size=`awk 'BEGIN{printf "%0.2f",'$swapused'/1024}'`
	dbus set swap_on_loaded=1
	http_response "成功挂载了虚拟内存！</br>大小：$swap_mount_size MB &nbsp;&nbsp;&nbsp; 已使用：$swap_used_size MB"
fi