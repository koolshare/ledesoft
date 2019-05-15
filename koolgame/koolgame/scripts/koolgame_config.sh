#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
source $KSROOT/bin/helper.sh
eval `dbus export koolgame_`
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
lan_ipaddr=`uci get network.lan.ipaddr`
LOCK_FILE=/var/lock/koolgame.lock
LOG_FILE=/tmp/upload/koolgame_log.txt
IFIP=`echo $koolgame_basic_server|grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}|:"`
mkdir -p /koolshare/configs
ISP_DNS1=`cat /tmp/resolv.conf.auto|cut -d " " -f 2|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 2p`
ISP_DNS2=`cat /tmp/resolv.conf.auto|cut -d " " -f 2|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 3p`
# dns for china
[ "$koolgame_dns_china" == "1" ] && [ -n "$ISP_DNS1" ] && CDN="$ISP_DNS1"
[ "$koolgame_dns_china" == "1" ] && [ -z "$ISP_DNS1" ] && CDN="114.114.114.114"
[ "$koolgame_dns_china" == "2" ] && CDN="223.5.5.5"
[ "$koolgame_dns_china" == "3" ] && CDN="223.6.6.6"
[ "$koolgame_dns_china" == "4" ] && CDN="114.114.114.114"
[ "$koolgame_dns_china" == "5" ] && CDN="114.114.115.115"
[ "$koolgame_dns_china" == "6" ] && CDN="1.2.4.8"
[ "$koolgame_dns_china" == "7" ] && CDN="210.2.4.8"
[ "$koolgame_dns_china" == "8" ] && CDN="112.124.47.27"
[ "$koolgame_dns_china" == "9" ] && CDN="114.215.126.16"
[ "$koolgame_dns_china" == "10" ] && CDN="180.76.76.76"
[ "$koolgame_dns_china" == "11" ] && CDN="119.29.29.29"
[ "$koolgame_dns_china" == "12" ] && CDN="$koolgame_dns_china_user"
# dns for koolgame
[ "$koolgame_dns_foreign" == "1" ] && KDF="208.67.220.220:53"
[ "$koolgame_dns_foreign" == "2" ] && KDF="8.8.8.8:53"
[ "$koolgame_dns_foreign" == "3" ] && KDF="8.8.4.4:53"
[ "$koolgame_dns_foreign" == "4" ] && KDF="$koolgame_dns_foreign_user"	
# ==========================================================================================
# stop first
restore_dnsmasq_conf(){
	# delete custom.conf
	if [ -f /tmp/dnsmasq.d/custom.conf ];then
		echo_date 删除 /tmp/dnsmasq.d/custom.conf
		rm -rf /tmp/dnsmasq.d/custom.conf
	fi
	echo_date 删除 KOOLGAME 相关的名单配置文件.
	# remove conf under /jffs/etc/dnsmasq.d
	rm -rf /tmp/dnsmasq.d/cdn.conf
	rm -rf /tmp/dnsmasq.d/custom.conf
	rm -rf /tmp/dnsmasq.d/wblist.conf
	rm -rf /tmp/dnsmasq.d/ssserver.conf
	rm -rf /tmp/sscdn.conf
	rm -rf /tmp/custom.conf
	rm -rf /tmp/wblist.conf
}

restore_start_file(){
	echo_date 清除firewall中相关的 KOOLGAME 启动命令...
	uci -q batch <<-EOT
	  delete firewall.ks_koolgame
	  commit firewall
	EOT
}

kill_process(){
	#--------------------------------------------------------------------------
	koolgame=$(ps | grep "koolgame" | grep -v "grep" | grep -vw "koolgame")
	pdu=$(ps | grep "pdu" | grep -v "grep" | grep -vw "pdu")
	# kill koolgame
	if [ -n "$koolgame" ]; then 
		echo_date 关闭 KOOLGAME 进程...
		killall koolgame >/dev/null 2>&1
	fi
	# kill pdu
	if [ -n "$pdu" ]; then 
		echo_date 关闭pdu进程...
		killall pdu >/dev/null 2>&1
	fi
}

# ==========================================================================================
# try to resolv the koolgame server ip if it is domain...
resolv_server_ip(){
	if [ -z "$IFIP" ];then
		echo_date 使用nslookup方式解析 KOOLGAME 的ip地址
			server_ip=`nslookup "$koolgame_basic_server" 114.114.114.114 | sed '1,4d' | awk '{print $3}' | grep -v :|awk 'NR==1{print}'`

		if [ -n "$server_ip" ];then
			echo_date  KOOLGAME 的ip地址解析成功：$server_ip.
			koolgame_basic_server="$server_ip"
			koolgame_basic_server_ip="$server_ip"
		else
			# get pre-resoved ip in skipd
			koolgame_basic_server=`dbus get koolgame_basic_server`
			echo_date  KOOLGAME 的ip地址解析失败，将由koolgame自己解析.
		fi
	else
		echo_date 检测到你的 KOOLGAME 已经是IP格式：$koolgame_basic_server,跳过解析... 
		koolgame_basic_server_ip="$koolgame_basic_server"
	fi
}

creat_game2_json(){
	# create shadowsocks config file...
	if [ "$(uci get network.lan.type)" == "bridge" ];then
		bridge=br-lan
	else
		bridge=$(uci get network.lan.ifname)
	fi
	
	echo_date 创建 KOOLGAME 配置文件到/koolshare/configs/koolgame.json
	cat > /koolshare/configs/koolgame.json <<-EOF
		{
		    "server":"$koolgame_basic_server",
		    "server_port":$koolgame_basic_port,
		    "local_port":3333,
		    "sock5_port":23456,
		    "dns2ss":7913,
		    "dns_server":"$KDF",
		    "password":"$koolgame_basic_password",
		    "timeout":600,
		    "method":"$koolgame_basic_method",
		    "use_tcp":$koolgame_basic_udp,
		    "bridge":"$bridge"
		}
	EOF
}

#--------------------------------------------------------------------------------------
create_dnsmasq_conf(){
	# append user dnsmasq settings
	rm -rf /tmp/custom.conf
	if [ -n "$koolgame_dnsmasq" ];then
		echo_date 添加自定义dnsmasq设置到/tmp/custom.conf
		echo "$koolgame_dnsmasq" | base64_decode | sort -u >> /tmp/custom.conf
	fi
	
	# append china site
	rm -rf /tmp/sscdn.conf
	if [ "$koolgame_dns_plan" == "2" ];then
		echo_date 生成cdn加速列表到/tmp/sscdn.conf，加速用的dns：$CDN
		echo "#for china site CDN acclerate" >> /tmp/sscdn.conf
		cat $KSROOT/configs/koolgame/cdn.txt | sed "s/^/server=&\/./g" | sed "s/$/\/&$CDN/g" | sort | awk '{if ($0!=line) print;line=$0}' >>/tmp/sscdn.conf
	fi

	# append white domain list, bypass koolgame
	rm -rf /tmp/wblist.conf
	# github need to go koolgame
	echo "#for router itself" >> /tmp/wblist.conf
	echo "server=/.google.com.tw/127.0.0.1#7913" >> /tmp/wblist.conf
	echo "ipset=/.google.com.tw/router" >> /tmp/wblist.conf
	echo "server=/.github.com/127.0.0.1#7913" >> /tmp/wblist.conf
	echo "ipset=/.github.com/router" >> /tmp/wblist.conf
	echo "server=/.github.io/127.0.0.1#7913" >> /tmp/wblist.conf
	echo "ipset=/.github.io/router" >> /tmp/wblist.conf
	echo "server=/.raw.githubusercontent.com/127.0.0.1#7913" >> /tmp/wblist.conf
	echo "ipset=/.raw.githubusercontent.com/router" >> /tmp/wblist.conf
	echo "server=/.apnic.net/127.0.0.1#7913" >> /tmp/wblist.conf
	echo "ipset=/.apnic.net/router" >> /tmp/wblist.conf
	echo "server=/.openwrt.org/127.0.0.1#7913" >> /tmp/wblist.conf
	echo "ipset=/.openwrt.org/router" >> /tmp/wblist.conf	
	# append white domain list,not through koolgame
	wanwhitedomain=$(echo $koolgame_wan_white_domain | base64_decode)
	if [ -n "$koolgame_wan_white_domain" ];then
		echo_date 应用域名白名单
		echo "#for white_domain" >> //tmp/wblist.conf
		for wan_white_domain in $wanwhitedomain
		do 
			echo "$wan_white_domain" | sed "s/^/server=&\/./g" | sed "s/$/\/127.0.0.1#7913/g" >> /tmp/wblist.conf
			echo "$wan_white_domain" | sed "s/^/ipset=&\/./g" | sed "s/$/\/white_list/g" >> /tmp/wblist.conf
		done
	fi
	# apple 和microsoft不能走koolgame
	echo "#for special site" >> //tmp/wblist.conf
	for wan_white_domain2 in "apple.com" "microsoft.com"
	do 
		echo "$wan_white_domain2" | sed "s/^/server=&\/./g" | sed "s/$/\/$CDN#53/g" >> /tmp/wblist.conf
		echo "$wan_white_domain2" | sed "s/^/ipset=&\/./g" | sed "s/$/\/white_list/g" >> /tmp/wblist.conf
	done
	
	# append black domain list,through koolgame
	wanblackdomain=$(echo $koolgame_wan_black_domain | base64_decode)
	if [ -n "$koolgame_wan_black_domain" ];then
		echo_date 应用域名黑名单
		echo "#for black_domain" >> /tmp/wblist.conf
		for wan_black_domain in $wanblackdomain
		do 
			echo "$wan_black_domain" | sed "s/^/server=&\/./g" | sed "s/$/\/127.0.0.1#7913/g" >> /tmp/wblist.conf
			echo "$wan_black_domain" | sed "s/^/ipset=&\/./g" | sed "s/$/\/black_list/g" >> /tmp/wblist.conf
		done
	fi
	# ln conf
	# custom dnsmasq
	rm -rf /tmp/dnsmasq.d/custom.conf
	if [ -f /tmp/custom.conf ];then
		echo_date 创建域自定义dnsmasq配置文件软链接到/tmp/dnsmasq.d/custom.conf
		mv /tmp/custom.conf /tmp/dnsmasq.d/custom.conf
	fi
	# custom dnsmasq
	rm -rf /tmp/dnsmasq.d/wblist.conf
	if [ -f /tmp/wblist.conf ];then
		echo_date 创建域名黑/白名单软链接到/tmp/dnsmasq.d/wblist.conf
		mv /tmp/wblist.conf /tmp/dnsmasq.d/wblist.conf
	fi
	rm -rf /tmp/dnsmasq.d/cdn.conf
	if [ -f /tmp/sscdn.conf ];then
		echo_date 创建cdn加速列表软链接/tmp/dnsmasq.d/cdn.conf
		mv /tmp/sscdn.conf /tmp/dnsmasq.d/cdn.conf
	fi
	rm -rf /tmp/dnsmasq.d/gfwlist.conf

	if [ ! -f /tmp/dnsmasq.d/gfwlist.conf ] && [ "$koolgame_dns_plan" == "1" ];then
		echo_date 创建gfwlist的软连接到/tmp/dnsmasq.d/文件夹.
		ln -sf $KSROOT/configs/koolgame/gfwlist.conf /tmp/dnsmasq.d/gfwlist.conf
	fi

	echo_date DNS解析方案默认国外优先，优先解析国外DNS.
	echo "server=127.0.0.1#7913" >> /tmp/dnsmasq.d/ssserver.conf
	echo "no-resolv" >> /tmp/dnsmasq.d/ssserver.conf
}

#--------------------------------------------------------------------------------------
auto_start(){
	# nat start
	echo_date 添加nat-start触发事件...
	uci -q batch <<-EOT
	  delete firewall.ks_shadowsocks
	  set firewall.ks_koolgame=include
	  set firewall.ks_koolgame.type=script
	  set firewall.ks_koolgame.path=/koolshare/scripts/koolgame_config.sh
	  set firewall.ks_koolgame.family=any
	  set firewall.ks_koolgame.reload=1
	  commit firewall
	EOT

	# auto start
	[ ! -L "/etc/rc.d/S98koolgame.sh" ] && ln -sf $KSROOT/init.d/S98koolgame.sh /etc/rc.d/S98koolgame.sh
}

#=======================================================================================
start_koolgame(){
	# Start koolgame
	pdu=`ps|grep pdu|grep -v grep`
	if [ -z "$pdu" ]; then
		echo_date 开启pdu进程，用于优化mtu...
		pdu br-lan /tmp/var/pdu.pid >/dev/null 2>&1
		sleep 1
	fi
	echo_date 开启 KOOLGAME 主进程...
	start-stop-daemon -S -q -b -m -p /tmp/var/koolgame.pid -x koolgame -- -c /koolshare/configs/koolgame.json
}

# =======================================================================================================
flush_nat(){
	echo_date 尝试先清除已存在的iptables规则，防止重复添加
	# flush rules and set if any
	iptables -t nat -D OUTPUT -j KOOLGAME > /dev/null 2>&1
	iptables -t nat -D OUTPUT -p tcp -m set --match-set router dst -j REDIRECT --to-ports 3333 > /dev/null 2>&1
	ip_nat_exist=`iptables -t nat -L PREROUTING | grep -c KOOLGAME`
	ip_mangle_exist=`iptables -t mangle -L PREROUTING | grep -c KOOLGAME`
	if [ -n "$ip_nat_exist" ]; then
		for i in `seq $ip_nat_exist`
		do
			iptables -t nat -D PREROUTING -p tcp -j KOOLGAME >/dev/null 2>&1
		done
	fi

	if [ -n "$ip_mangle_exist" ]; then
		for i in `seq $ip_mangle_exist`
		do
			iptables -t mangle -D PREROUTING -p udp -j KOOLGAME >/dev/null 2>&1
		done
	fi

	iptables -t nat -F KOOLGAME	>/dev/null 2>&1 && iptables -t nat -X KOOLGAME >/dev/null 2>&1
	iptables -t mangle -F KOOLGAME >/dev/null 2>&1 && iptables -t mangle -X KOOLGAME >/dev/null 2>&1
	iptables -t mangle -F KOOLGAME_GAM >/dev/null 2>&1 && iptables -t mangle -X KOOLGAME_GAM >/dev/null 2>&1

	# flush chromecast rule
	ss_chromecast=`dbus get ss_basic_chromecast`
	ss_enable=`iptables -t nat -L SHADOWSOCKS 2>/dev/null |wc -l`
	chromecast_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|awk '{print $1}'`
	if [ `dbus get koolproxy_enable` == "1" ]; then
		[ -n "$chromecast_nu" ] && iptables -t nat -D PREROUTING $chromecast_nu >/dev/null 2>&1
	else
		if [ "$ss_chromecast" == "0" ] || [ "$ss_enable" -eq 0 ]; then
			[ -n "$chromecast_nu" ] && iptables -t nat -D PREROUTING $chromecast_nu >/dev/null 2>&1
		fi
	fi

	#flush_ipset
	echo_date 先清空已存在的ipset名单，防止重复添加
	ipset -F chnroute >/dev/null 2>&1 && ipset -X chnroute >/dev/null 2>&1
	ipset -F white_list >/dev/null 2>&1 && ipset -X white_list >/dev/null 2>&1
	ipset -F black_list >/dev/null 2>&1 && ipset -X black_list >/dev/null 2>&1
	ipset -F router >/dev/null 2>&1 && ipset -X router >/dev/null 2>&1

	#remove_redundant_rule
	ip_rule_exist=`ip rule show | grep "fwmark 0x7 lookup 310" | grep -c 310`
	if [ -n "ip_rule_exist" ];then
		echo_date 清除重复的ip rule规则.
		until [ "$ip_rule_exist" = 0 ]
		do 
			#ip rule del fwmark 0x07 table 310
			ip rule del fwmark 0x07 table 310 pref 789
			ip_rule_exist=`expr $ip_rule_exist - 1`
		done
	fi

	# remove_route_table
	echo_date 删除ip route规则.
	ip route del local 0.0.0.0/0 dev lo table 310 >/dev/null 2>&1
}

# creat ipset rules
creat_ipset(){
	echo_date 创建ipset名单
	ipset -! create router nethash && ipset flush router
	ipset -! create chnroute nethash && ipset flush chnroute
	sed -e "s/^/add chnroute &/g" $KSROOT/configs/koolgame/chnroute.txt | awk '{print $0} END{print "COMMIT"}' | ipset -R
}

gen_special_ip() {
	[ ! -z "$koolgame_basic_server_ip" ] && SERVER_IP=$koolgame_basic_server_ip || SERVER_IP=""
	cat <<-EOF
		0.0.0.0/8
		10.0.0.0/8
		100.64.0.0/10
		127.0.0.0/8
		169.254.0.0/16
		172.16.0.0/12
		192.0.0.0/24
		192.0.2.0/24
		192.31.196.0/24
		192.52.193.0/24
		192.88.99.0/24
		192.168.0.0/16
		192.175.48.0/24
		198.18.0.0/15
		198.51.100.0/24
		203.0.113.0/24
		224.0.0.0/4
		240.0.0.0/4
		255.255.255.255
		223.5.5.5
		223.6.6.6
		114.114.114.114
		114.114.115.115
		1.2.4.8
		210.2.4.8
		112.124.47.27
		114.215.126.16
		180.76.76.76
		119.29.29.29
		$ISP_DNS1
		$ISP_DNS2
		$SERVER_IP
EOF
}

gen_tg_ip() {
	cat <<-EOF
		149.154.0.0/16
		91.108.4.0/22
		91.108.56.0/24
		109.239.140.0/24
		67.198.55.0/24
EOF
}

add_white_black_ip(){
	# black/white ip/cidr
	ipset -! restore <<-EOF
		create black_list hash:net hashsize 64
		create white_list hash:net hashsize 64		
		$(gen_tg_ip | sed -e "s/^/add black_list /")
		$(gen_special_ip | sed -e "s/^/add white_list /")		
EOF
	
	if [ ! -z $koolgame_wan_black_ip ];then
		koolgame_wan_black_ip=`dbus get koolgame_wan_black_ip|base64_decode|sed '/\#/d'`
		echo_date 应用IP/CIDR黑名单
		for ip in $koolgame_wan_black_ip
		do
			ipset -! add black_list $ip >/dev/null 2>&1
		done
	fi
	
	if [ ! -z $koolgame_wan_white_ip ];then
		koolgame_wan_white_ip=`echo $koolgame_wan_white_ip|base64_decode|sed '/\#/d'`
		echo_date 应用IP/CIDR白名单
		for ip in $koolgame_wan_white_ip
		do
			ipset -! add white_list $ip >/dev/null 2>&1
		done
	fi
}

get_action_chain() {
	case "$1" in
		0)
			echo "RETURN"
		;;
		1)
			echo "KOOLGAME_GAM"
		;;
	esac
}

get_mode_name() {
	case "$1" in
		0)
			echo "不通过koolgame"
		;;
		1)
			echo "通过koolgame"
		;;
	esac
}

factor(){
	if [ -z "$1" ] || [ -z "$2" ]; then
		echo ""
	else
		echo "$2 $1"
	fi
}

get_jump_mode(){
	case "$1" in
		0)
			echo "j"
		;;
		*)
			echo "g"
		;;
	esac
}

lan_acess_control(){
	# lan access control
	acl_nu=`dbus list koolgame_acl_mode|sort -n -t "=" -k 2|cut -d "=" -f 1 | cut -d "_" -f 4`
	if [ -n "$acl_nu" ]; then
		for acl in $acl_nu
		do
			ipaddr=`dbus get koolgame_acl_ip_$acl`
			proxy_mode=`dbus get koolgame_acl_mode_$acl`
			proxy_name=`dbus get koolgame_acl_name_$acl`
			mac=`dbus get koolgame_acl_mac_$acl`

			[ -n "$ipaddr" ] && [ -z "$mac" ] && echo_date 加载ACL规则：【$ipaddr】模式为：$(get_mode_name $proxy_mode)
			[ -z "$ipaddr" ] && [ -n "$mac" ] && echo_date 加载ACL规则：【$mac】模式为：$(get_mode_name $proxy_mode)
			[ -n "$ipaddr" ] && [ -n "$mac" ] && echo_date 加载ACL规则：【$ipaddr】【$mac】模式为：$(get_mode_name $proxy_mode)
			# acl magic happens here
			iptables -t mangle -A KOOLGAME $(factor $ipaddr "-s") $(factor $mac "-m mac --mac-source") -p udp -$(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
			iptables -t mangle -A KOOLGAME $(factor $ipaddr "-s") $(factor $mac "-m mac --mac-source") -p tcp -$(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
		done
		echo_date 加载ACL规则：其余主机模式为：$(get_mode_name $koolgame_acl_default_mode)
	else
		#koolgame_acl_default_mode="1"
		echo_date 加载ACL规则：所有模式为：$(get_mode_name $koolgame_basic_mode)
	fi
}

apply_nat_rules(){
	#----------------------BASIC RULES---------------------
	echo_date 写入iptables规则到mangle表中...
	# 创建KOOLGAME mangle rule
	iptables -t mangle -N KOOLGAME
	# IP/cidr/白域名 白名单控制（不走koolgame）
	iptables -t mangle -A KOOLGAME -m set --match-set white_list dst -j RETURN
	#-----------------------FOR GAMEMODE---------------------
	# 创建游戏模式udp rule
	iptables -t mangle -N KOOLGAME_GAM
	# IP/CIDR/域名 黑名单控制（走koolgame）
	iptables -t mangle -A KOOLGAME_GAM -p tcp -m set --match-set black_list dst -j TTL --ttl-set 188
	# cidr黑名单控制-chnroute（走koolgame）
	iptables -t mangle -A KOOLGAME_GAM -p tcp -m set ! --match-set chnroute dst -j TTL --ttl-set 188

	#load_tproxy
	ip rule add fwmark 0x07 table 310 pref 789
	ip route add local 0.0.0.0/0 dev lo table 310
	# IP/CIDR/域名 黑名单控制（走koolgame）
	iptables -t mangle -A KOOLGAME_GAM -p udp -m set --match-set black_list dst -j TPROXY --on-port 3333 --tproxy-mark 0x07
	# cidr黑名单控制-chnroute（走koolgame）
	iptables -t mangle -A KOOLGAME_GAM -p udp -m set ! --match-set chnroute dst -j TPROXY --on-port 3333 --tproxy-mark 0x07
	#-------------------------------------------------------
	# 局域网黑名单（不走koolgame）/局域网黑名单（走koolgame）
	lan_acess_control
	# 其余主机默认模式
	iptables -t mangle -A KOOLGAME -j $(get_action_chain $koolgame_acl_default_mode)
	# 重定向所有流量到透明代理端口
	iptables -t nat -N KOOLGAME
	iptables -t nat -A KOOLGAME -p tcp -m ttl --ttl-eq 188 -j REDIRECT --to 3333
	#获取默认规则行号
	PR_INDEX=`iptables -t nat -L PREROUTING|tail -n +3|sed -n -e '/^prerouting_rule/='`
	[ -n "$BL_INDEX" ] && let RULE_INDEX=$BL_INDEX+1
	KP_INDEX=`iptables -t nat -L PREROUTING|tail -n +3|sed -n -e '/^KOOLPROXY/='`
	[ -n "$KP_INDEX" ] && let RULE_INDEX=$KP_INDEX+1
	#确保添加到默认规则之后
	iptables -t nat -I PREROUTING $RULE_INDEX -p tcp -j KOOLGAME
	iptables -t mangle -I PREROUTING 1 -p udp -j KOOLGAME
	# router itself
	iptables -t nat -I OUTPUT -j KOOLGAME
	iptables -t nat -A OUTPUT -p tcp -m set --match-set router dst -j REDIRECT --to-ports 3333	
}

chromecast(){
	LOG1=开启chromecast功能（DNS劫持功能）
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
# =======================================================================================================
load_nat(){
	echo_date "加载nat规则!"
	flush_nat
	creat_ipset
	add_white_black_ip
	apply_nat_rules
	chromecast
}

restart_dnsmasq(){
	# Restart dnsmasq
	echo_date 重启dnsmasq服务...
	/etc/init.d/dnsmasq restart >/dev/null 2>&1
}

write_version(){
	dbus set koolgame_version=`cat $KSROOT/configs/koolgame/version`
}

# for debug
get_status(){
	echo =========================================================
	echo `date` 123
	echo "PID of this script: $$"
	echo "PPID of this script: $PPID"
	echo ------------------------------------
	ps -l|grep $$|grep -v grep
	echo ------------------------------------
	ps -l|grep $PPID|grep -v grep
	echo ------------------------------------
	iptables -nvL PREROUTING -t nat
}

detect_ss(){
	SS_NU=`iptables -nvL PREROUTING -t nat |sed 1,2d | sed -n '/SHADOWSOCKS/='` 2>/dev/null
	if [ -n "$SS_NU" ];then
		echo_date 检测到你开启了SS！！！
		echo_date KOOLGAME不能和SS混用，请关闭SS后启用本插件！！
		echo_date 退出 KOOLGAME 启动...
		dbus set koolgame_basic_enable=0
		echo_date ------------------------- KOOLGAME 退出启动 -------------------------
		sleep 5
		echo XU6J03M6
		http_response "KOOLGAME 和 SS不能同时开启！"
		sleep 1
		exit 1
	else
		echo_date KOOLGAME符合启动条件！~
	fi
}


restart_koolgame(){
	flock -x 1000
	{
		# router is on boot
		ONSTART=`ps -l|grep $PPID|grep -v grep|grep S98koolgame`
		# used by web for start/restart; or by system for startup by S98koolgame.sh in rc.d
		echo_date ---------------------- LEDE 固件 KOOLGAME -----------------------
		detect_ss
		# stop first
		restore_dnsmasq_conf
		[ -z "$IFIP" ] && [ -z "$ONSTART" ] && restart_dnsmasq
		flush_nat
		restore_start_file
		kill_process
		echo_date ---------------------------------------------------------------------------------------
		# start
		resolv_server_ip
		[ -z "$ONSTART" ] && creat_game2_json
		create_dnsmasq_conf
		auto_start
		start_koolgame
		load_nat
		restart_dnsmasq
		write_version
		echo_date ------------------------- KOOLGAME 启动完毕 -------------------------
		# get_status >> /tmp/koolgame_start.txt
	}
	flock -u 1000
} 1000<>"$LOCK_FILE"

stop_koolgame(){
	flock -x 1000
	{
		#only used by web stop
		echo_date ---------------------- LEDE 固件 koolgame -----------------------
		restore_dnsmasq_conf
		restart_dnsmasq
		flush_nat
		restore_start_file
		kill_process
		echo_date ------------------------- KOOLGAME 成功关闭 -------------------------
	}
	flock -u 1000
} 1000<>"$LOCK_FILE"


restart_by_nat(){
	flock -x 1000
	{
		# for nat
		detect_ss
		restore_dnsmasq_conf
		kill_process
		load_nat
		start_koolgame
		create_dnsmasq_conf
		restart_dnsmasq
	}
	flock -u 1000
} 1000<>"$LOCK_FILE"


# used by rc.d
case $1 in
start)
	if [ "$koolgame_basic_enable" == "1" ];then
		restart_koolgame
	else
		stop_koolgame
    fi
	;;
stop)
	stop_koolgame
	;;
*)
	[ -z "$2" ] && restart_by_nat
	;;
esac

# used by httpdb
case $2 in
1)
	if [ "$koolgame_basic_enable" == "1" ];then
		restart_koolgame > $LOG_FILE
	else
		stop_koolgame > $LOG_FILE
	fi
	echo XU6J03M6 >> $LOG_FILE
	http_response $1
	;;
2)
	# remove all koolgame config in skipd
	echo_date 尝试关闭 KOOLGAME... > $LOG_FILE
	sh $KSROOT/scripts/koolgame_config.sh stop
	echo_date 开始清理 KOOLGAME 配置... >> $LOG_FILE
	confs=`dbus list koolgame | cut -d "=" -f 1 | grep -v "version"`
	for conf in $confs
	do
		echo_date 移除$conf >> $LOG_FILE
		dbus remove $conf
	done
	echo_date 设置一些默认参数... >> $LOG_FILE
	dbus set koolgame_basic_enable="0"
	echo_date 完成！ >> $LOG_FILE
	http_response $1
	;;
3)
	#备份ss配置
	echo "" > $LOG_FILE
	mkdir -p $KSROOT/webs/files
	dbus list koolgame | grep -v "status" | grep -v "enable" | grep -v "version" | sed 's/=/=\"/' | sed 's/$/\"/g'|sed 's/^/dbus set /' | sed '1 i\\n' | sed '1 isource /koolshare/scripts/base.sh' |sed '1 i#!/bin/sh' > $KSROOT/webs/files/koolgame_conf_backup.sh
	http_response "$1"
	echo XU6J03M6 >> $LOG_FILE
	;;
4)
	#用备份的koolgame_conf_backup.sh 去恢复配置
	echo_date "开始恢复KOOLGAME配置..." > $LOG_FILE
	file_nu=`ls /tmp/upload/koolgame_conf_backup | wc -l`
	i=20
	until [ -n "$file_nu" ]
	do
	    i=$(($i-1))
	    if [ "$i" -lt 1 ];then
	        echo_date "错误：没有找到恢复文件!"
	        exit
	    fi
	    sleep 1
	done
	format=`cat /tmp/upload/koolgame_conf_backup.sh |grep dbus`
	if [ -n "format" ];then
		echo_date "检测到正确格式的配置文件！" >> $LOG_FILE
		cd /tmp/upload
		chmod +x koolgame_conf_backup.sh
		echo_date "恢复中..." >> $LOG_FILE
		sh koolgame_conf_backup.sh
		sleep 1
		rm -rf /tmp/upload/koolgame_conf_backup.sh
		echo_date "恢复完毕！" >> $LOG_FILE
	else
		echo_date "配置文件格式错误！" >> $LOG_FILE
	fi
	http_response "$1"
	echo XU6J03M6 >> $LOG_FILE
	;;
5)
	#打包KOOLGAME插件
	rm -rf /tmp/koolgame
	rm -rf /koolshare/webs/files/koolgame*
	echo_date "开始打包..." > $LOG_FILE
	echo_date "请等待一会儿...下载会自动开始." >> $LOG_FILE
	mkdir -p /koolshare/webs/files
	cd /tmp
	mkdir -p koolgame/bin
	mkdir -p koolgame/scripts
	mkdir -p koolgame/init.d
	mkdir -p koolgame/webs
	mkdir -p koolgame/webs/res
	mkdir -p koolgame/configs/koolgame
	cp $KSROOT/scripts/koolgame_install.sh /tmp/koolgame/install.sh
	cp $KSROOT/scripts/uninstall_koolgame.sh /tmp/koolgame/uninstall.sh
	cp $KSROOT/bin/koolgame /tmp/koolgame/bin/
	cp $KSROOT/bin/pdu /tmp/koolgame/bin/
	cp $KSROOT/scripts/koolgame_* /tmp/koolgame/scripts/
	cp $KSROOT/init.d/S98koolgame.sh /tmp/koolgame/init.d/
	cp $KSROOT/webs/Module_koolgame.asp /tmp/koolgame/webs/
	cp $KSROOT/webs/res/icon-koolgame* /tmp/koolgame/webs/res/
	cp -rf $KSROOT/configs/koolgame /tmp/koolgame/configs/
	tar -czv -f /koolshare/webs/files/koolgame.tar.gz koolgame/
	mv koolgame.tar.gz /koolshare/webs/files/
	rm -rf /tmp/koolgame*
	echo_date "打包完毕！该包可以在LEDE软件中心离线安装哦~" >> $LOG_FILE
	http_response "$1"
	echo XU6J03M6 >> $LOG_FILE
	sleep 10 
	rm -rf /koolshare/webs/files/koolgame.tar.gz
	;;
esac