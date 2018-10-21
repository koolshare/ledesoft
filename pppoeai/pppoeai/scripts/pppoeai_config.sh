#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export pppoeai_`
alias echo_date='echo $(date +%Y年%m月%d日\ %X)'
LOGFILE="/tmp/upload/pp_log.txt"

get_count_mode(){
	case "$1" in
		1)
			echo "$1"
		;;
		2)
			echo "$1,$2"
		;;
		3)
			echo "$1,$2,$3"
		;;
	esac
}

start_pppoeai(){
	local IP
	#循环开始
	local pppdcheck=`pidof pppd|wc -l`
	if [ "$pppdcheck" == "0" ]; then
		cat /dev/null >$LOGFILE
		echo_date "未检测到拨号程序，请先设置好wan口并拨号成功再运行拨号助手！"
		echo XU6J03M6 >> $LOGFILE
		exit 0
	fi
	[ "$pppoeai_count" == "1" ] && current_ip=$(ifconfig |grep -A1 "ppp" |grep "inet" |awk -F  P-t-P '{print $1}'|awk -F \: '{print $2}'|awk -vOFS="." -F . '{print $1}'|head -1)
	[ "$pppoeai_count" == "2" ] && current_ip=$(ifconfig |grep -A1 "ppp" |grep "inet" |awk -F  P-t-P '{print $1}'|awk -F \: '{print $2}'|awk -vOFS="." -F . '{print $1,$2}'|head -1)
	[ "$pppoeai_count" == "3" ] && current_ip=$(ifconfig |grep -A1 "ppp" |grep "inet" |awk -F  P-t-P '{print $1}'|awk -F \: '{print $2}'|awk -vOFS="." -F . '{print $1,$2,$3}'|head -1)
		
	match_ip="pppoeai_ip$pppoeai_count"
	match_check=$(dbus get $match_ip|grep $current_ip)
	#检查IP是否为空
	if [ -n "$current_ip" ]; then
		echo_date "当前拨号IP:$current_ip"
		echo_date "需要匹配IP:$(dbus get $match_ip)"
		echo ""
		#获取IP头是否正确
		if [ -n "$match_check" ]; then
			echo_date "太棒了，匹配成功，完成本次进程!"
			echo XU6J03M6 >> $LOGFILE
			exit 0
		else
			sleep 1
			echo_date "运气不太好，未匹配成功，重新拨号!"
			ifdown $pppoeai_wan
			sleep 2
			echo_date "准备下次拨号!"
			sleep 3
			echo_date "--------------------------------------------------------"
			current_ip=""
			echo_date ""
			echo_date "开始拨号..."
			ifup  $pppoeai_wan>/dev/null 2>&1 &
			echo_date "等待10秒完成拨号..."
			sleep 10
		fi
	else
		echo_date_date "正在拨号中，等待5秒..."
		sleep 5
	fi
}

creat_start_up(){
	[ ! -L "/etc/rc.d/S18pppoeai.sh" ] && ln -sf /koolshare/init.d/S18pppoeai.sh /etc/rc.d/S18pppoeai.sh
if [ ! -f "/etc/hotplug.d/iface/00-pppoeai" ]; then
cat>/etc/hotplug.d/iface/00-pppoeai<<EOF
#!/bin/sh
case "\$ACTION" in
	ifup)
		sh /koolshare/scripts/pppoeai_config.sh
	;;
esac
EOF
fi
}

del_start_up(){
	rm -rf /etc/hotplug.d/iface/00-pppoeai >/dev/null 2>&1
}


if [ "$pppoeai_enable" == "1" ]; then
	cat /dev/null >$LOGFILE
	del_start_up
	creat_start_up
	start_pppoeai >> $LOGFILE
 	echo XU6J03M6 >> $LOGFILE
  	http_response '服务已开启！页面将在3秒后刷新'
else
	del_start_up
	echo_date "服务未开启，请先开启助手。"
	echo XU6J03M6 >> $LOGFILE
	http_response '服务已关闭！页面将在3秒后刷新'
fi

