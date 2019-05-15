#! /bin/sh

alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export koolproxy_`
SOFT_DIR=/koolshare
KP_DIR=$SOFT_DIR/koolproxy
LOCK_FILE=/var/lock/koolproxy.lock
# 一定要按照source.list的排列顺序
SOURCE_LIST=$KP_DIR/data/source.list

write_user_txt(){
	if [ -n "$koolproxy_custom_rule" ];then
		echo $koolproxy_custom_rule| base64_decode |sed 's/\\n/\n/g' > $KP_DIR/data/rules/user.txt
	fi
}

load_rules(){
	sed -i '1,7s/1/0/g' $SOURCE_LIST

	if [ "$koolproxy_encryption_rules" == "1" -a "koolproxy_oline_rules" == "0" -a "$koolproxy_easylist_rules" == "0" -a "$koolproxy_abx_rules" == "0" -a "$koolproxy_fanboy_rules" == "0" ]; then
		echo_date 加载【加密规则】
		sed -i '3,4s/0/1/g' $SOURCE_LIST
	else
		if [ "$koolproxy_oline_rules" == "1" ]; then
			echo_date 加载【绿坝规则】
			sed -i '1,2s/0/1/g;4s/0/1/g' $SOURCE_LIST
		fi
		if [ "$koolproxy_encryption_rules" == "1" ]; then
			echo_date 加载【加密规则】
			sed -i '3,4s/0/1/g' $SOURCE_LIST
		fi
	fi
}

start_koolproxy(){
	write_user_txt
	kp_version=`koolproxy -h | head -n1 | awk '{print $6}'`
	dbus set koolproxy_binary_version="koolproxy $kp_version "
	echo_date 开启koolproxy主进程！
	load_rules
	[ -f "$KSROOT/bin/koolproxy" ] && rm -rf $KSROOT/bin/koolproxy
	[ ! -L "$KSROOT/bin/koolproxy" ] && ln -sf $KSROOT/koolproxy/koolproxy $KSROOT/bin/koolproxy
	if [ "$koolproxy_mode_enable" == "1" ]; then
		echo_date 开启【进阶模式】
		[ "$koolproxy_mode" == "0" ] && echo_date 选择【不过滤】
		[ "$koolproxy_mode" == "1" ] && echo_date 选择【全局模式】
		[ "$koolproxy_mode" == "2" ] && echo_date 选择【带HTTPS的全局模式】
		[ "$koolproxy_mode" == "3" ] && echo_date 选择【黑名单模式】
		[ "$koolproxy_mode" == "4" ] && echo_date 选择【带HTTPS的黑名单模式】
#		[ "$koolproxy_mode" == "5" ] && echo_date 选择【全端口模式】
		[ "$koolproxy_encryption_rules" == "1" -a "koolproxy_oline_rules" == "0" -a "$koolproxy_easylist_rules" == "0" -a "$koolproxy_abx_rules" == "0" -a "$koolproxy_fanboy_rules" == "0" ] && echo_date 选择【视频模式】
	else
		[ "$koolproxy_base_mode" == "0" ] && echo_date 选择【不过滤】	
		[ "$koolproxy_base_mode" == "1" ] && echo_date 选择【全局模式】
		[ "$koolproxy_base_mode" == "2" ] && echo_date 选择【黑名单模式】
		[ "$koolproxy_encryption_rules" == "1" -a "koolproxy_oline_rules" == "0" -a "$koolproxy_easylist_rules" == "0" -a "$koolproxy_abx_rules" == "0" -a "$koolproxy_fanboy_rules" == "0" ] && echo_date 选择【视频模式】
	fi
	cd $KP_DIR && koolproxy -d --ttl 188 --ttlport 3001 --ipv6
}

stop_koolproxy(){
	echo_date 关闭koolproxy主进程...
	kill -9 `pidof koolproxy` >/dev/null 2>&1
	killall koolproxy >/dev/null 2>&1
}

creat_start_up(){
	[ ! -L "/etc/rc.d/S93koolproxy.sh" ] && {
		echo_date 加入开机自动启动...
		ln -sf $SOFT_DIR/init.d/S93koolproxy.sh /etc/rc.d/S93koolproxy.sh
	}
}

write_nat_start(){
	echo_date 添加nat-start触发事件...
	uci -q batch <<-EOT
	  delete firewall.ks_koolproxy
	  set firewall.ks_koolproxy=include
	  set firewall.ks_koolproxy.type=script
	  set firewall.ks_koolproxy.path=/koolshare/koolproxy/kp_config.sh
	  set firewall.ks_koolproxy.family=any
	  set firewall.ks_koolproxy.reload=1
	  commit firewall
	EOT
}

remove_nat_start(){
	echo_date 删除nat-start触发...
	uci -q batch <<-EOT
	  delete firewall.ks_koolproxy
	  commit firewall
	EOT
}
# ===============================

add_ipset_conf(){
	if [ "$koolproxy_mode_enable" == "1" ]; then
		if [ "$koolproxy_mode" == "3" ];then
			echo_date 添加黑名单软连接...
			rm -rf /tmp/dnsmasq.d/koolproxy_ipset.conf
			ln -sf $KP_DIR/data/koolproxy_ipset.conf /tmp/dnsmasq.d/koolproxy_ipset.conf
			dnsmasq_restart=1
		fi
	else
		if [ "$koolproxy_base_mode" == "2" ];then
			echo_date 添加黑名单软连接...
			rm -rf /tmp/dnsmasq.d/koolproxy_ipset.conf
			ln -sf $KP_DIR/data/koolproxy_ipset.conf /tmp/dnsmasq.d/koolproxy_ipset.conf
			dnsmasq_restart=1
		fi		
	fi
}

remove_ipset_conf(){
	if [ -L "/tmp/dnsmasq.d/koolproxy_ipset.conf" ];then
		echo_date 移除黑名单软连接...
		rm -rf /tmp/dnsmasq.d/koolproxy_ipset.conf
	fi
}

del_dns_takeover(){
	ss_enable=`iptables -t nat -L SHADOWSOCKS 2>/dev/null |wc -l`
	ss_chromecast=`dbus get ss_basic_chromecast`
	[ -z "$ss_chromecast" ] && ss_chromecast=0
	if [ "$ss_enable" == "0" ]; then
		chromecast_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|awk '{print $1}'`
		[ -n "$chromecast_nu" ] && iptables -t nat -D PREROUTING $chromecast_nu >/dev/null 2>&1
	else
		[ "$ss_chromecast" == "0" ] && [ -n "$chromecast_nu" ] && iptables -t nat -D PREROUTING $chromecast_nu >/dev/null 2>&1
	fi
}

restart_dnsmasq(){
	if [ "$dnsmasq_restart" == "1" ];then
		echo_date 重启dnsmasq进程...
		/etc/init.d/dnsmasq restart > /dev/null 2>&1
	fi
}

write_reboot_job(){
	# start setvice
	[ ! -f  "/etc/crontabs/root" ] && touch /etc/crontabs/root
	CRONTAB=`cat /etc/crontabs/root|grep KoolProxy_check_chain.sh`

	[ -z "$CRONTAB" ] && echo_date 写入KP过滤代理链守护... && echo  "*/30 * * * * $SOFT_DIR/scripts/KoolProxy_check_chain.sh" >> /etc/crontabs/root
#	if [ "1" == "$koolproxy_reboot" ]; then
#		[ -z "$CRONTAB" ] && echo_date 开启插件定时重启，每天"$koolproxy_reboot_hour"时，自动重启插件... && echo  "0 $koolproxy_reboot_hour * * * $KP_DIR/kp_config.sh restart" >> /etc/crontabs/root 
#	elif [ "2" == "$koolproxy_reboot" ]; then
#		[ -z "$CRONTAB" ] && echo_date 开启插件间隔重启，每隔"$koolproxy_reboot_inter_hour"时，自动重启插件... && echo  "0 */$koolproxy_reboot_inter_hour * * * $KP_DIR/kp_config.sh restart" >> /etc/crontabs/root 
#	fi
}

remove_reboot_job(){
	[ ! -f  "/etc/crontabs/root" ] && touch /etc/crontabs/root
	jobexist=`cat /etc/crontabs/root|grep KoolProxy_check_chain.sh`
	KP_ENBALE=`dbus get koolproxy_enable`

	# kill crontab job
	if [ ! "$KP_ENBALE" == "1" ];then
		if [ ! -z "$jobexist" ];then
			echo_date 删除KP过滤代理链守护...
			sed -i '/KoolProxy_check_chain/d' /etc/crontabs/root >/dev/null 2>&1
		fi
	fi
}

creat_ipset(){
	echo_date 创建ipset名单
	# Load ipset netfilter kernel modules and kernel modules
	ipset -! create white_kp_list nethash
	ipset -! create black_koolproxy iphash
	cat $KP_DIR/data/rules/koolproxy.txt $KP_DIR/data/rules/daily.txt $KP_DIR/data/rules/user.txt | grep -Eo "(.\w+\:[1-9][0-9]{1,4})/" | grep -Eo "([0-9]{1,5})" | sort -un | sed -e '$a\80' -e '$a\443' | sed -e "s/^/-A kp_full_port &/g" -e "1 i\-N kp_full_port bitmap:port range 0-65535 " | ipset -R -!
}

gen_special_ip() {
	ethernet=`ifconfig | grep eth | wc -l`
	if [ "$ethernet" -ge "2" ]; then
		dhcp_mode=`ubus call network.interface.wan status | grep \"proto\" | sed -e 's/^[ \t]\"proto\": //g' -e 's/"//g' -e 's/,//g'`
	else
		:
	fi
	cat <<-EOF | grep -E "^([0-9]{1,3}\.){3}[0-9]{1,3}"
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
		$([ "$dhcp_mode" == "pppoe" ] && ubus call network.interface.wan status | grep \"address\" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
EOF
}

add_white_black_ip(){
	echo_date 添加ipset名单
	ipset -! restore <<-EOF || return 1
		create white_kp_list hash:net hashsize 64
		$(gen_special_ip | sed -e "s/^/add white_kp_list /")
EOF
	ipset -A black_koolproxy 110.110.110.110 >/dev/null 2>&1
	return 0
}

get_mode_name() {
	case "$1" in
		0)
			echo "不过滤"
		;;
		1)
			echo "全局模式"
		;;
		2)
			echo "带HTTPS的全局模式"
		;;
		3)
			echo "黑名单模式"
		;;
		4)
			echo "带HTTPS的黑名单模式"
		;;
		5)
			echo "全端口模式"
		;;							
	esac
}

get_base_mode_name() {
	case "$1" in
		0)
			echo "不过滤"
		;;
		1)
			echo "全局模式"
		;;
		2)
			echo "黑名单模式"
		;;							
	esac
}

get_jump_mode(){
	case "$1" in
		0)
			echo "-j"
		;;
		*)
			echo "-g"
		;;
	esac
}

get_action_chain() {
	case "$1" in
		0)
			echo "RETURN"
		;;
		1)
			echo "KP_HTTP"
		;;
		2)
			echo "KP_HTTPS"
		;;
		3)
			echo "KP_BLOCK_HTTP"
		;;
		4)
			echo "KP_BLOCK_HTTPS"
		;;				
		5)
			echo "KP_ALL_PORT"
		;;		
	esac
}

get_base_mode() {
	case "$1" in
		0)
			echo "RETURN"
		;;
		1)
			echo "KP_HTTP"
		;;
		2)
			echo "KP_BLOCK_HTTP"
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

flush_nat(){
	echo_date 移除nat规则...
	cd /tmp
	iptables -t nat -S | grep -E "KOOLPROXY|KOOLPROXY_ACT|KP_HTTP|KP_HTTPS|KP_BLOCK_HTTP|KP_BLOCK_HTTPS|KP_ALL_PORT" | sed 's/-A/iptables -t nat -D/g'|sed 1,7d > clean.sh && chmod 777 clean.sh && ./clean.sh
	iptables -t nat -X KOOLPROXY > /dev/null 2>&1
	iptables -t nat -X KOOLPROXY_ACT > /dev/null 2>&1	
	iptables -t nat -X KP_HTTP > /dev/null 2>&1
	iptables -t nat -X KP_HTTPS > /dev/null 2>&1
	iptables -t nat -X KP_BLOCK_HTTP > /dev/null 2>&1
	iptables -t nat -X KP_BLOCK_HTTPS > /dev/null 2>&1	
	iptables -t nat -X KP_ALL_PORT > /dev/null 2>&1
	ipset -F black_koolproxy > /dev/null 2>&1 && ipset -X black_koolproxy > /dev/null 2>&1
	ipset -F white_kp_list > /dev/null 2>&1 && ipset -X white_kp_list > /dev/null 2>&1
	ipset -F kp_full_port > /dev/null 2>&1 && ipset -X kp_full_port > /dev/null 2>&1
}

get_acl_para(){
	echo `dbus get koolproxy_acl_list|sed 's/>/\n/g'|sed '/^$/d'|awk NR==$1{print}|cut -d "<" -f "$2"`
}

lan_acess_control(){
	# lan access control
#	[ -z "$koolproxy_acl_default" ] && koolproxy_acl_default=1
	acl_nu=`dbus get koolproxy_acl_list|sed 's/>/\n/g'|sed '/^$/d'|sed '/^ /d'|wc -l`
	if [ -n "$acl_nu" ]; then
		min="1"
		max="$acl_nu"
		while [ $min -le $max ]
		do
			#echo_date $min $max
			proxy_name=`get_acl_para $min 1`
			ipaddr=`get_acl_para $min 2`
			mac=`get_acl_para $min 3`
			proxy_mode=`get_acl_para $min 4`
		
			[ -n "$ipaddr" ] && [ -z "$mac" ] && echo_date 加载ACL规则：【$ipaddr】模式为：$(get_mode_name $proxy_mode)
			[ -z "$ipaddr" ] && [ -n "$mac" ] && echo_date 加载ACL规则：【$mac】模式为：$(get_mode_name $proxy_mode)
			[ -n "$ipaddr" ] && [ -n "$mac" ] && echo_date 加载ACL规则：【$ipaddr】【$mac】模式为：$(get_mode_name $proxy_mode)
			#echo iptables -t nat -A KOOLPROXY $(factor $ipaddr "-s") $(factor $mac "-m mac --mac-source") -p tcp $(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
			iptables -t nat -A KOOLPROXY $(factor $ipaddr "-s") $(factor $mac "-m mac --mac-source") -p tcp $(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
			min=`expr $min + 1`
		done
		if [ "$koolproxy_mode_enable" == "1" ]; then
			echo_date 加载ACL规则：其余主机模式为：$(get_mode_name $koolproxy_mode)		
		else
			echo_date 加载ACL规则：其余主机模式为：$(get_base_mode_name $koolproxy_base_mode)
		fi
	else
		if [ "$koolproxy_mode_enable" == "1" ]; then
			echo_date 加载ACL规则：所有模式为：$(get_mode_name $koolproxy_mode)	
		else
			echo_date 加载ACL规则：所有模式为：$(get_base_mode_name $koolproxy_base_mode)
		fi
	fi
}

load_nat(){
	echo_date 加载nat规则！
	#----------------------BASIC RULES---------------------
	echo_date 写入iptables规则到nat表中...
	# 创建KOOLPROXY nat rule
	iptables -t nat -N KOOLPROXY
	# 创建KOOLPROXY_ACT nat rule
	iptables -t nat -N KOOLPROXY_ACT
	# 匹配TTL走TTL Port
	iptables -t nat -A KOOLPROXY_ACT -p tcp -m ttl --ttl-eq 188 -j REDIRECT --to 3001
	# 不匹配TTL走正常Port
	iptables -t nat -A KOOLPROXY_ACT -p tcp -j REDIRECT --to 3000
	# 局域网地址不走KP
	iptables -t nat -A KOOLPROXY -m set --match-set white_kp_list dst -j RETURN
	# 生成对应CHAIN
	iptables -t nat -N KP_HTTP
	iptables -t nat -A KP_HTTP -p tcp -m multiport --dport 80 -j KOOLPROXY_ACT
	iptables -t nat -N KP_HTTPS
	iptables -t nat -A KP_HTTPS -p tcp -m multiport --dport 80,443 -j KOOLPROXY_ACT
	iptables -t nat -N KP_BLOCK_HTTP
	iptables -t nat -A KP_BLOCK_HTTP -p tcp -m multiport --dport 80 -m set --match-set black_koolproxy dst -j KOOLPROXY_ACT
	iptables -t nat -N KP_BLOCK_HTTPS
	iptables -t nat -A KP_BLOCK_HTTPS -p tcp -m multiport --dport 80,443 -m set --match-set black_koolproxy dst -j KOOLPROXY_ACT	
	iptables -t nat -N KP_ALL_PORT
	#iptables -t nat -A KP_ALL_PORT -p tcp -j KOOLPROXY_ACT
	# 端口控制 
	if [ "$koolproxy_port" == "1" ]; then
		echo_date 开启端口控制：【$koolproxy_bp_port】
		iptables -t nat -A KP_ALL_PORT -p tcp -m multiport ! --dport $koolproxy_bp_port -m set --match-set kp_full_port dst -j KOOLPROXY_ACT		
	else
		iptables -t nat -A KP_ALL_PORT -p tcp -m set --match-set kp_full_port dst -j KOOLPROXY_ACT
	fi
	# 局域网控制
	lan_acess_control
	# 剩余流量转发到缺省规则定义的链中
	[ "$koolproxy_mode_enable" == "1" ] && iptables -t nat -A KOOLPROXY -p tcp -j $(get_action_chain $koolproxy_mode)
	[ ! "$koolproxy_mode_enable" == "1" ] && iptables -t nat -A KOOLPROXY -p tcp -j $(get_base_mode $koolproxy_base_mode)
	# 重定所有流量到 KOOLPROXY
	# 全局模式和视频模式
	PR_NU=`iptables -nvL PREROUTING -t nat |sed 1,2d | sed -n '/prerouting_rule/='`
	if [ "$PR_NU" == "" ]; then
		PR_NU=1
	else
		let PR_NU+=1
	fi	
#	[ "$koolproxy_mode" == "1" ] || [ "$koolproxy_mode" == "3" ] && iptables -t nat -I PREROUTING "$PR_NU" -p tcp -j KOOLPROXY
	iptables -t nat -I PREROUTING "$PR_NU" -p tcp -j KOOLPROXY
	# ipset 黑名单模式
#	[ "$koolproxy_mode" == "2" ] && iptables -t nat -I PREROUTING "$PR_NU" -p tcp -m set --match-set black_koolproxy dst -j KOOLPROXY
}

dns_takeover(){
	ss_chromecast=`uci -q get shadowsocks.@global[0].dns_53`
	ss_enable=`iptables -t nat -L PREROUTING | grep SHADOWSOCKS |wc -l`
	[ -z "$ss_chromecast" ] && ss_chromecast=0
	lan_ipaddr=`uci get network.lan.ipaddr`
	#chromecast=`iptables -t nat -L PREROUTING -v -n|grep "dpt:53"`
	chromecast_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|awk '{print $1}'`
	is_right_lanip=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53" |grep "$lan_ipaddr"`
	if [ "$koolproxy_mode_enable" == "1" ]; then
		if [ "$koolproxy_mode" == "3" ]; then
			if [ -z "$chromecast_nu" ]; then
				echo_date 黑名单模式开启DNS劫持
				iptables -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
			else
				if [ -z "$is_right_lanip" ]; then
					echo_date 黑名单模式开启DNS劫持
					iptables -t nat -D PREROUTING $chromecast_nu >/dev/null 2>&1
					iptables -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
				else
					echo_date DNS劫持规则已经添加，跳过~
				fi
			fi
		else
			if [ "$ss_chromecast" != "1" ] || [ "$ss_enable" -eq 0 ]; then
				if [ -n "$chromecast_nu" ]; then
					echo_date 全局过滤模式下删除DNS劫持
					iptables -t nat -D PREROUTING $chromecast_nu >/dev/null 2>&1
				fi
			fi
		fi	
	else	
		if [ "$koolproxy_base_mode" == "2" ]; then
			if [ -z "$chromecast_nu" ]; then
				echo_date 黑名单模式开启DNS劫持
				iptables -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
			else
				if [ -z "$is_right_lanip" ]; then
					echo_date 黑名单模式开启DNS劫持
					iptables -t nat -D PREROUTING $chromecast_nu >/dev/null 2>&1
					iptables -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
				else
					echo_date DNS劫持规则已经添加，跳过~
				fi
			fi
		else
			if [ "$ss_chromecast" != "1" ] || [ "$ss_enable" -eq 0 ]; then
				if [ -n "$chromecast_nu" ]; then
					echo_date 全局过滤模式下删除DNS劫持
					iptables -t nat -D PREROUTING $chromecast_nu >/dev/null 2>&1
				fi
			fi
		fi
	fi
} 

detect_cert(){
	if [ ! -f $KP_DIR/data/private/ca.key.pem -o ! -f $KP_DIR/data/certs/ca.crt ]; then
		echo_date 开始生成koolproxy证书，用于https过滤！
		cd $KP_DIR/data && sh gen_ca.sh
	fi
}

set_lock(){
	exec 1000>"$LOCK_FILE"
	flock -x 1000
}

unset_lock(){
	flock -u 1000
	rm -rf "$LOCK_FILE"
}

case $1 in
start)
	set_lock
	echo_date ================== koolproxy启用 =================
	rm -rf /tmp/upload/user.txt && ln -sf $KSROOT/koolproxy/data/rules/user.txt /tmp/upload/user.txt
	detect_cert
	start_koolproxy
	add_ipset_conf && restart_dnsmasq
	creat_ipset
	add_white_black_ip
	load_nat
	dns_takeover
	write_nat_start
	write_reboot_job
	echo_date =================================================
	unset_lock
	;;
restart)
	set_lock
	# now stop
	echo_date ================== 关闭 =================
	rm -rf /tmp/upload/user.txt && ln -sf $KSROOT/koolproxy/data/rules/user.txt /tmp/upload/user.txt
	remove_reboot_job
	del_dns_takeover
	remove_ipset_conf
	remove_nat_start
	flush_nat
	stop_koolproxy
	# now start
	echo_date ================== koolproxy启用 =================
	detect_cert
	start_koolproxy
	add_ipset_conf && restart_dnsmasq
	creat_ipset
	add_white_black_ip
	load_nat
	dns_takeover
	creat_start_up
	write_nat_start
	write_reboot_job
	echo_date koolproxy启用成功，请等待日志窗口自动关闭，页面会自动刷新...
	echo_date =================================================
	unset_lock
	;;
stop)
	set_lock
	remove_reboot_job
	del_dns_takeover
	remove_ipset_conf && restart_dnsmasq
	remove_nat_start
	flush_nat
	stop_koolproxy
	unset_lock
	;;
*)
	set_lock
	flush_nat
	creat_ipset
	add_white_black_ip
	load_nat
	dns_takeover
	unset_lock
	;;
esac
