#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
source $KSROOT/bin/helper.sh
eval `dbus export sgame_`
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
lan_ipaddr=`uci get network.lan.ipaddr`
LOCK_FILE=/var/lock/sgame.lock
LOG_FILE=/tmp/upload/sgame_log.txt
IFIP=`echo $sgame_basic_server|grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}|:"`
CONFIG=/var/etc/shadowvpn.conf

# stop first
restore_dnsmasq_conf(){
	# delete sgcustom.conf
	if [ -f /tmp/dnsmasq.d/sgcustom.conf ];then
		echo_date 删除自定义Dnsmqsq配置
		rm -rf /tmp/dnsmasq.d/sgcustom.conf
	fi
	echo_date 删除 SGame 相关的名单配置文件.
	# remove conf under /jffs/etc/dnsmasq.d
	rm -rf /tmp/dnsmasq.d/sgconfig.conf
}

#--------------------------------------------------------------------------------------
create_dnsmasq_conf(){
	local ISP_DNS1 ISP_DNS2 CDN KDF
	ISP_DNS1=`cat /tmp/resolv.conf.auto|cut -d " " -f 2|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 2p`
	ISP_DNS2=`cat /tmp/resolv.conf.auto|cut -d " " -f 2|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 3p`
	# dns for china
	[ "$sgame_dns_china" == "1" ] && [ -n "$ISP_DNS1" ] && CDN="$ISP_DNS1"
	[ "$sgame_dns_china" == "1" ] && [ -z "$ISP_DNS1" ] && CDN="114.114.114.114"
	[ "$sgame_dns_china" == "2" ] && CDN="223.5.5.5"
	[ "$sgame_dns_china" == "3" ] && CDN="223.6.6.6"
	[ "$sgame_dns_china" == "4" ] && CDN="114.114.114.114"
	[ "$sgame_dns_china" == "5" ] && CDN="114.114.115.115"
	[ "$sgame_dns_china" == "6" ] && CDN="1.2.4.8"
	[ "$sgame_dns_china" == "7" ] && CDN="210.2.4.8"
	[ "$sgame_dns_china" == "8" ] && CDN="112.124.47.27"
	[ "$sgame_dns_china" == "9" ] && CDN="114.215.126.16"
	[ "$sgame_dns_china" == "10" ] && CDN="180.76.76.76"
	[ "$sgame_dns_china" == "11" ] && CDN="119.29.29.29"
	[ "$sgame_dns_china" == "12" ] && CDN="$sgame_dns_china_user"
	# dns for sgame
	[ "$sgame_dns_foreign" == "1" ] && KDF="208.67.220.220"
	[ "$sgame_dns_foreign" == "2" ] && KDF="8.8.8.8"
	[ "$sgame_dns_foreign" == "3" ] && KDF="8.8.4.4"
	[ "$sgame_dns_foreign" == "4" ] && KDF="$sgame_dns_foreign_user"	
# ==========================================================================================
	# append user dnsmasq settings
	rm -rf /tmp/sgcustom.conf
	if [ -n "$sgame_dnsmasq" ];then
		echo_date 添加自定义dnsmasq设置到/tmp/sgcustom.conf
		echo "$sgame_dnsmasq" | base64_decode | sort -u >> /tmp/sgcustom.conf
	fi
	
	cat > /tmp/dnsmasq.d/sgconfig.conf <<EOF
all-servers
no-resolv
server=$CDN
server=$KDF
server=/cn/$CDN
server=/taobao.com/223.5.5.5
server=/.apple.com/223.5.5.5
EOF
}

restart_dnsmasq(){
	# Restart dnsmasq
	echo_date 重启dnsmasq服务...
	/etc/init.d/dnsmasq restart >/dev/null 2>&1
}


#--------------------------------------------------------------------------------------
auto_start(){
	# auto start
	[ ! -L "/etc/rc.d/S99sgame.sh" ] && ln -sf $KSROOT/init.d/S99sgame.sh /etc/rc.d/S99sgame.sh
}

kill_process(){
	#--------------------------------------------------------------------------	
	local sgame=$(ps | grep -v grep | grep shadowvpn)
	# kill sgame
	if [ -n "$sgame" ]; then 
		echo_date 关闭 ShadowVPN 进程...
		$KSROOT/bin/shadowvpn -c $CONFIG -s stop >/dev/null 2>&1
	fi
	local speederv2=$(pidof speederv2)
	if [ -n "$speederv2" ];then 
		echo_date 关闭 SpeederV2 进程...
		killall speederv2 >/dev/null 2>&1
	fi
}

# ==========================================================================================
# try to resolv the sgame server ip if it is domain...
resolv_server_ip(){
	if [ -z "$IFIP" ];then
		echo_date 使用nslookup方式解析 sgame 的ip地址
			server_ip=`nslookup "$sgame_basic_server" 114.114.114.114 | sed '1,4d' | awk '{print $3}' | grep -v :|awk 'NR==1{print}'`

		if [ -n "$server_ip" ];then
			echo_date  sgame 的ip地址解析成功：$server_ip.
			sgame_basic_server="$server_ip"
			sgame_basic_server_ip="$server_ip"
		else
			# get pre-resoved ip in skipd
			sgame_basic_server=`dbus get sgame_basic_server`
			echo_date  sgame 的ip地址解析失败，将由sgame自己解析.
		fi
	else
		echo_date 检测到你的 sgame 已经是IP格式：$sgame_basic_server,跳过解析... 
		sgame_basic_server_ip="$sgame_basic_server"
	fi
}

start_speeder(){
	local disable_obscure timeout mode report mtu jitter interval drop
	if [ "$sgame_udp_enable" == "1" ];then
		echo_date 生成 SpeederV2 配置文件...
		[ "$sgame_udp_disableobscure" == "1" ] && disable_obscure="--disable-obscure" || disable_obscure=""
		[ -n "$sgame_udp_timeout" ] && timeout="--timeout $sgame_udp_timeout" || timeout=""
		[ -n "$sgame_udp_mode" ] && mode="--mode $sgame_udp_mode" || mode=""
		[ -n "$sgame_udp_report" ] && report="--report $sgame_udp_report" || report=""
		[ -n "$sgame_udp_mtu" ] && mtu="--mtu $sgame_udp_mtu" || mtu=""
		[ -n "$sgame_udp_jitter" ] && jitter="--jitter $sgame_udp_jitter" || jitter=""
		[ -n "$sgame_udp_interval" ] && interval="-interval $sgame_udp_interval" || interval=""
		[ -n "$sgame_udp_drop" ] && drop="-random-drop $sgame_udp_drop" || drop=""
		echo_date 开启 SpeederV2 进程
		speederv2 -c -l 0.0.0.0:1092 -r $sgame_udp_server:$sgame_udp_port -k "$sgame_udp_password" -f "$sgame_udp_fec" $timeout $mode $report $mtu $jitter $interval $drop $disable_obscure $sgame_udp_other --fifo /tmp/fifo.file >/dev/null 2>&1 &
	fi
}

#=======================================================================================
start_sgame(){
	if [ ! -c "/dev/net/tun" ]; then
		mkdir -p /dev/net
		mknod /dev/net/tun c 10 200
		chmod 0666 /dev/net/tun
	fi
	until ip route show 0/0 | grep -q "^default"; do
		sleep 1
	done
	# Start speederV2
	start_speeder
	# Start sgame
	if [ "$sgame_udp_enable" == "1" ];then
		sgame_basic_server="127.0.0.1"
		sgame_basic_port="1092"
	fi
	echo_date 生成 ShadowVPN 配置文件...
	mkdir -p $(dirname $CONFIG)
	cat <<-EOF >$CONFIG
		server=$sgame_basic_server
		port=$sgame_basic_port
		password=$sgame_basic_password
		mode=client
		concurrency=1
		net=$sgame_basic_subnet
		mtu=$sgame_basic_mtu
		intf=tun0
		up=$KSROOT/sgame/client_up.sh
		down=$KSROOT/sgame/client_down.sh
		pidfile=/var/run/shadowvpn.pid
		logfile=/tmp/upload/sgame_log.txt
EOF
	if [ -n "$sgame_basic_token" ]; then
		echo "user_token=$sgame_basic_token" >>$CONFIG
	fi
	echo_date 开启 ShadowVPN 主进程...
	$KSROOT/bin/shadowvpn -c $CONFIG -s start >/dev/null 2>&1
}

chromecast(){
	LOG1=开启chromecast功能（DNS劫持功能）
	kp_mode=`/koolshare/bin/dbus get koolproxy_mode`
	kp_enable=`iptables -t nat -L PREROUTING | grep KOOLPROXY |wc -l`
	chromecast_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|awk '{print $1}'`
	is_right_lanip=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53" |grep "$lan_ipaddr"`
	
	if [ -z "$chromecast_nu" ]; then
		iptables -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
		echo_date $LOG1
	else
		if [ -z "$is_right_lanip" ]; then
			echo_date 黑名单模式开启DNS劫持
			iptables -t nat -D PREROUTING $chromecast_nu >/dev/null 2>&1
			iptables -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
		else
			echo_date DNS劫持规则已经添加，跳过~
		fi
	fi
}

detect_ss(){
	SS_NU=`iptables -nvL PREROUTING -t nat |sed 1,2d | sed -n '/SHADOWSOCKS/='` 2>/dev/null
	if [ -n "$SS_NU" -a $sgame_basic_mode != "2" ];then
		echo_date 检测到你开启了SS且SGame不在黑名单模式！！！
		echo_date SGame黑名单以外模式不能和SS混用，请关闭SS后启用本插件！！
		echo_date 退出 SGame 启动...
		dbus set sgame_basic_enable=0
		echo_date ------------------------- SGame 退出启动 -------------------------
		sleep 5
		echo XU6J03M6
		http_response "SGame黑名单以外模式和SS不能同时开启！"
		sleep 1
		exit 1
	else
		echo_date SGame符合启动条件！~
	fi
}


restart_sgame(){
	# used by web for start/restart; or by system for startup by S98sgame.sh in rc.d
	while [ -f "$LOCK_FILE" ]; do
		sleep 1
	done
	echo_date ---------------------- LEDE 固件 SGame -----------------------
	detect_ss
	# stop first
	restore_dnsmasq_conf
	kill_process
	sleep 5
	echo_date ---------------------------------------------------------------------------------------
	[ -f "$LOCK_FILE" ] && return 1
	touch "$LOCK_FILE"
	# start
	resolv_server_ip
	create_dnsmasq_conf
	auto_start
	start_sgame
	restart_dnsmasq
	rm -f "$LOCK_FILE"
	return 0
}
stop_sgame(){
	#only used by web stop
	while [ -f "$LOCK_FILE" ]; do
		sleep 1
	done
	echo_date ---------------------- LEDE 固件 SGame -----------------------
	restore_dnsmasq_conf
	restart_dnsmasq
	kill_process
}
restart_by_nat(){
	# for nat
	while [ -f "$LOCK_FILE" ]; do
		sleep 1
	done
	detect_ss
	restore_dnsmasq_conf
	kill_process
	sleep 5
	start_sgame
	create_dnsmasq_conf
	restart_dnsmasq
}

# used by rc.d
case $1 in
start)
	if [ "$sgame_basic_enable" == "1" ];then
		restart_sgame
	else
		stop_sgame
    fi
	;;
stop)
	stop_sgame
	;;
*)
	[ -z "$2" ] && restart_by_nat
	;;
esac

# used by httpdb
case $2 in
1)
	if [ "$sgame_basic_enable" == "1" ];then
		restart_sgame > $LOG_FILE
	else
		stop_sgame > $LOG_FILE
	fi
	echo XU6J03M6 >> $LOG_FILE
	http_response $1
	;;
2)
	# remove all sgame config in skipd
	echo_date 尝试关闭 SGame... > $LOG_FILE
	sh $KSROOT/scripts/sgame_config.sh stop
	echo_date 开始清理 SGame 配置... >> $LOG_FILE
	confs=`dbus list sgame | cut -d "=" -f 1 | grep -v "version"`
	for conf in $confs
	do
		echo_date 移除$conf >> $LOG_FILE
		dbus remove $conf
	done
	echo_date 设置一些默认参数... >> $LOG_FILE
	dbus set sgame_basic_enable="0"
	echo_date 完成！ >> $LOG_FILE
	http_response $1
	;;
3)
	#备份ss配置
	echo "" > $LOG_FILE
	mkdir -p $KSROOT/webs/files
	dbus list sgame | grep -v "status" | grep -v "enable" | grep -v "version" | sed 's/=/=\"/' | sed 's/$/\"/g'|sed 's/^/dbus set /' | sed '1 i\\n' | sed '1 isource /koolshare/scripts/base.sh' |sed '1 i#!/bin/sh' > $KSROOT/webs/files/sgame_conf_backup.sh
	http_response "$1"
	echo XU6J03M6 >> $LOG_FILE
	;;
4)
	#用备份的sgame_conf_backup.sh 去恢复配置
	echo_date "开始恢复sgame配置..." > $LOG_FILE
	format=`cat /tmp/upload/sgame_conf_backup.sh |grep dbus`
	if [ -n "format" ];then
		echo_date "检测到正确格式的配置文件！" >> $LOG_FILE
		cd /tmp/upload
		chmod +x sgame_conf_backup.sh
		echo_date "恢复中..." >> $LOG_FILE
		sh sgame_conf_backup.sh
		sleep 1
		rm -rf /tmp/upload/sgame_conf_backup.sh
		echo_date "恢复完毕！" >> $LOG_FILE
	else
		echo_date "配置文件格式错误！" >> $LOG_FILE
	fi
	http_response "$1"
	echo XU6J03M6 >> $LOG_FILE
	;;
esac