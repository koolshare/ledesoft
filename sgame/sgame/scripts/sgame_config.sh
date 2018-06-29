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
CONFIG=/var/etc/tinyvpn.conf

restore_dnsmasq_conf(){
	# delete sgcustom.conf
	if [ -f /tmp/dnsmasq.d/sgcustom.conf ];then
		echo_date 删除自定义Dnsmqsq配置
		rm -rf /tmp/dnsmasq.d/sgcustom.conf
	fi
	echo_date 删除 SGame 相关的名单配置文件.
	rm -rf /tmp/dnsmasq.d/sgconfig.conf
}

#--------------------------------------------------------------------------------------
create_dnsmasq_conf(){
	local ISP_DNS1 ISP_DNS2 CDN KDF dnsserver1 dnsserver2
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
	if [ "$sgame_dns_plan" == "2" ];then
		echo_date DNS解析方案默认国外优先，使用DNS：$KDF
		dnsserver1="$KDF"
		dnsserver2="199.91.73.222"
		[ ! -f /tmp/dnsmasq.d/sgcdn.conf ] && {
			echo_date 创建国内CDN解析优化配置文件
			[ -f /tmp/dnsmasq.d/sggfw.conf ] && rm -rf /tmp/dnsmasq.d/sggfw.conf
			cat $KSROOT/sgame/cdn.txt | sed "s/^/server=&\/./g" | sed "s/$/\/&$CDN/g" | sort | awk '{if ($0!=line) print;line=$0}' > /tmp/dnsmasq.d/sgcdn.conf
		}
	else
		echo_date DNS解析方案默认国内优先，使用DNS：$CDN
		dnsserver1="$CDN"
		dnsserver2="202.38.64.1"
		dnsserver2="121.40.144.82"
		[ ! -f /tmp/dnsmasq.d/sggfw.conf ] && {
			echo_date 创建国外GFW解析优化配置文件
			[ -f /tmp/dnsmasq.d/sgcdn.conf ] && rm -rf /tmp/dnsmasq.d/sgcdn.conf
			cat $KSROOT/sgame/gfw.txt | sed "s/^/server=&\/./g" | sed "s/$/\/&$KDF/g" | sort | awk '{if ($0!=line) print;line=$0}' > /tmp/dnsmasq.d/sggfw.conf
		}		
	fi
	
	cat > /tmp/dnsmasq.d/sgconfig.conf <<EOF
all-servers
no-resolv
server=$dnsserver1
server=$dnsserver2
server=/cn/$CDN
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
	local sgame=$(ps | grep -v grep | grep tinyvpn)
	# kill sgame
	if [ -n "$sgame" ]; then 
		echo_date 关闭 TinyVPN 进程...
		killall tinyvpn >/dev/null 2>&1
	fi
	local udp2raw=$(pidof udp2raw)
	if [ -n "$udp2raw" ];then 
		echo_date 关闭 udp2raw 进程...
		killall udp2raw >/dev/null 2>&1
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

check_dev_tun(){
	local tun=`ifconfig tun100`
	if [ -z "$tun" ];then
		echo_date 创建成持久型的TUN设备
		ip tuntap add tun100 mode tun
		ifconfig tun100 up
	fi
}

#=======================================================================================
add_route_mode(){
	local server foreigngateway chinagateway intf lannet lannet2 blackip

	intf="tun100"
	lannet=`echo $sgame_basic_subnet | awk 'BEGIN{FS="."}{print $1"."$2"."$3".1"}'`
	lannet2=`echo $sgame_basic_subnet | awk 'BEGIN{FS="."}{print $1"."$2"."$3".2"}'`

	if [ "$sgame_udp_enable" == "1" ];then
		server="$sgame_udp_server"
		ip route add $lannet dev $intf proto kernel scope link src $lannet2
	else
		server="$sgame_basic_server"
	fi

	[ "$sgame_basic_mode" != 1 ] && {
		chinagateway=`ubus call network.interface."$sgame_wan_china" status | grep nexthop | grep -oE '([0-9]{1,3}.){3}.[0-9]{1,3}'`
		[ -z "$chinagateway" ] && chinagateway=$(ip route show 0/0 | sed -e 's/.* via \([^ ]*\).*/\1/')
		echo_date "国内出口：$sgame_wan_china       网关: $chinagateway"	
	}

	foreigngateway=`ubus call network.interface."$sgame_wan_foreign" status | grep nexthop | grep -oE '([0-9]{1,3}.){3}.[0-9]{1,3}'`
	[ -z "$foreigngateway" ] && foreigngateway=$(ip route show 0/0 | sed -e 's/.* via \([^ ]*\).*/\1/')
	echo_date "VPN出口：$sgame_wan_foreign       网关: $foreigngateway"
	suf="dev $intf"
	ip route add $server via $foreigngateway

	if [ "$sgame_basic_mode" != 3 ]; then
		echo_date "VPN接口：$intf  网关: $lannet"
		ip route add 0.0.0.0/1 via $lannet dev $intf
		ip route add 128.0.0.0/1 via $lannet dev $intf
		echo_date "将默认路由设置到 VPN 通道"
		suf="via $chinagateway"
	fi

	[ "$sgame_basic_mode" == "1" ] && {
		echo_date "全局模式已经载入"
	}
	[ "$sgame_basic_mode" == "2" ] && {
		grep -E "^([0-9]{1,3}\.){3}[0-9]{1,3}" $KSROOT/sgame/chnroute.txt >/tmp/shadowvpn_routes
		sed -e "s/^/route add /" -e "s/$/ $suf/" /tmp/shadowvpn_routes | ip -batch -
		echo_date "大陆白名单模式已经载入"
	}
	[ "$sgame_basic_mode" == "3" ] && {
		blackip=`echo "$sgame_wan_black_ip" | base64_decode | sort -u`
		if [ -n "$blackip" ]; then
			grep -E "^([0-9]{1,3}\.){3}[0-9]{1,3}" $blackip >/tmp/shadowvpn_routes
			sed -e "s/^/route add /" -e "s/$/ $suf/" /tmp/shadowvpn_routes | ip -batch -
			echo_date "黑名单模式已经载入"
		else
			echo_date "你选择使用黑名单模式，但黑名单为空,加速器不会有任何效果！"
		fi
	}
	dbus set sgame_basic_modeold=$sgame_basic_mode
	dbus set sgame_basic_serverold=$server
}

del_route_mode(){
	ip route del $sgame_basic_serverold >/dev/null 2>&1
	if [ "$sgame_basic_modeold" != 3 ]; then
		ip route del 0.0.0.0/1
		ip route del 128.0.0.0/1
		echo_date "将默认路由从VPN通道变更到默认"
	fi
	if [ -f /tmp/shadowvpn_routes ]; then
		sed -e "s/^/route del /" /tmp/shadowvpn_routes | ip -batch -
		echo_date "VPN路由规则清理完成"
		rm -rf /tmp/shadowvpn_routes
	fi	
	echo_date ---------------------- SGame 成功关闭 -------------------------
}

#=======================================================================================
start_udp2raw(){
	if [ "$sgame_udp_enable" == "1" ];then
		echo_date 开启 Udp2raw 进程
		nohup udp2raw -c -l 127.0.0.1:1092 \
		-r $sgame_udp_server:$sgame_udp_port \
		-k "$sgame_udp_password" \
		--raw-mode $sgame_udp_mode \
		$sgame_udp_other \
		--log-level 2 -a& \
		2>/dev/null
		sleep 2
	fi
}

start_sgame(){
	check_dev_tun
	until ip route show 0/0 | grep -q "^default"; do
		sleep 1
	done
	# Start udp2raw
	start_udp2raw
	# Start sgame
	if [ "$sgame_udp_enable" == "1" ];then
		sgame_basic_server="127.0.0.1"
		sgame_basic_port="1092"
	fi
	echo_date 开启 TinyVPN 主进程...
	nohup tinyvpn -c -r $sgame_basic_server:$sgame_basic_port \
	--sub-net $sgame_basic_subnet \
	--tun-dev tun100 \
	--keep-reconnect \
	-k "$sgame_basic_password" \
	$sgame_basic_other \
	--log-level 2& \
	2>/dev/null
	sleep 2
	add_route_mode
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

detect_mwan3(){
	local mwan3run=`ps |grep mwan3|grep -v grep`
	if [ -n "$mwan3run" ];then
		echo_date 检测到你开启了MWAN3,将为你关闭！
		/usr/sbin/mwan3 stop 2>/dev/null
		sleep 1
	else
		echo_date SGame符合启动条件！~
	fi
}

start_mwan3(){
	/usr/sbin/mwan3 start >/dev/null 2>&1 &
	sleep 1
}

restart_sgame(){
	# used by web for start/restart; or by system for startup by S98sgame.sh in rc.d
	while [ -f "$LOCK_FILE" ]; do
		sleep 1
	done
	echo_date ---------------------- LEDE 固件 SGame ----------------------
	detect_mwan3
	# stop first
	restore_dnsmasq_conf
	kill_process
	del_route_mode
	sleep 5
	echo_date ---------------------- SGame 开始启动 ----------------------
	[ -f "$LOCK_FILE" ] && return 1
	touch "$LOCK_FILE"
	# start
	resolv_server_ip
	create_dnsmasq_conf
	auto_start
	start_sgame
	restart_dnsmasq
	rm -f "$LOCK_FILE"
	echo_date ---------------------- SGame 启动完毕 ----------------------
	echo_date "大吉大利，今晚吃鸡！"
	return 0
}
stop_sgame(){
	#only used by web stop
	while [ -f "$LOCK_FILE" ]; do
		sleep 1
	done
	echo_date ---------------------- LEDE 固件 SGame ----------------------
	restore_dnsmasq_conf
	restart_dnsmasq
	kill_process
	del_route_mode
	rm -rf /tmp/dnsmasq.d/sggfw.conf
	rm -rf /tmp/dnsmasq.d/sgcdn.conf
	start_mwan3
}
restart_by_nat(){
	# for nat
	while [ -f "$LOCK_FILE" ]; do
		sleep 1
	done
	detect_mwan3
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
dns)
	create_dnsmasq_conf
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