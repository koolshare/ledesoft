#! /bin/sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export koolproxy_`
SOFT_DIR=/jffs/koolshare
KP_DIR=$SOFT_DIR/koolproxy

write_user_txt(){
	if [ -n "$koolproxy_custom_rule" ];then
		echo $koolproxy_custom_rule| base64_decode |sed 's/\\n/\n/g' > $KP_DIR/data/user.txt
		#dbus remove koolproxy_custom_rule
	fi
}

start_koolproxy(){
	write_user_txt
	kp_version=`koolproxy -h | head -n1 | awk '{print $6}'`
	dbus set koolproxy_binary_version="koolprxoy $kp_version "
	echo_date 开启koolproxy主进程！
	cd $KP_DIR && koolproxy -d
}

stop_koolproxy(){
	echo_date 关闭koolproxy主进程...
	kill -9 `pidof koolproxy` >/dev/null 2>&1
	killall koolproxy >/dev/null 2>&1
}

# ===============================
# this part for start up wan/nat
creat_start_up(){
	echo_date 加入开机自动启动...
	[ ! -L "$SOFT_DIR/init.d/S93koolproxy.sh" ] && ln -sf $SOFT_DIR/scripts/KoolProxy_config.sh $SOFT_DIR/init.d/S93koolproxy.sh
}

write_nat_start(){
	echo_date 添加nat-start触发事件...
	[ ! -L "$SOFT_DIR/init.d/N93koolproxy.sh" ] && ln -sf $KP_DIR/kp_config.sh $SOFT_DIR/init.d/N93koolproxy.sh
}

remove_nat_start(){
	echo_date 删除nat-start触发...
	rm -rf $SOFT_DIR/init.d/N93koolproxy.sh
}
# ===============================

add_ipset_conf(){
	if [ "$koolproxy_mode" == "2" ];then
		echo_date 添加黑名单软连接...
		rm -rf /jffs/etc/dnsmasq.d/koolproxy_ipset.conf
		ln -sf $KP_DIR/data/koolproxy_ipset.conf /jffs/etc/dnsmasq.d/koolproxy_ipset.conf
		dnsmasq_restart=1
	fi
}

remove_ipset_conf(){
	if [ -L "/jffs/configs/dnsmasq.d/koolproxy_ipset.conf" ];then
		echo_date 移除黑名单软连接...
		rm -rf /jffs/etc/dnsmasq.d/koolproxy_ipset.conf
	fi
}

restart_dnsmasq(){
	if [ "$dnsmasq_restart" == "1" ];then
		echo_date 重启dnsmasq进程...
		service dnsmasq restart > /dev/null 2>&1
	fi
}

write_cron_job(){
	# start setvice
	if [ "1" == "$koolproxy_update" ]; then
		echo_date 开启规则定时更新，每天"$koolproxy_update_hour"时，检查在线规则更新...
		cru a koolproxy_update "* $koolproxy_update_hour * * * /bin/sh $SOFT_DIR/scripts/koolproxy_rule_update.sh"
	elif [ "2" == "$koolproxy_update" ]; then
		echo_date 开启规则定时更新，每隔"$koolproxy_update_inter_hour"时，检查在线规则更新...
		cru a koolproxy_update "* */$koolproxy_update_inter_hour * * * /bin/sh $SOFT_DIR/scripts/koolproxy_rule_update.sh"
	else
		echo_date 规则自动更新关闭状态，不启用自动更新...
	fi
}

kill_cron_job(){
	jobexist=`cru l|grep koolproxy_update`
	# kill crontab job
	if [ ! -z "$jobexist" ];then
		echo_date 关闭定时更新...
		sed -i '/koolproxy_update/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}

add_ss_event(){
	start=`dbus list __event__onssstart_|grep koolproxy`
	if [ -z "$start" ];then
	echo_date 添加ss事件触发：当ss启用或者重启，重新加载koolproxy的nat规则.
	dbus event onssstart_koolproxy $KP_DIR/koolproxy.sh
	fi
}

remove_ss_event(){
	dbus remove __event__onssstart_koolproxy
}

write_reboot_job(){
	# start setvice
	if [ "1" == "$koolproxy_reboot" ]; then
		echo_date 开启插件定时重启，每天"$koolproxy_reboot_hour"时，自动重启插件...
		cru a koolproxy_reboot "* $koolproxy_reboot_hour * * * /bin/sh $KP_DIR/koolproxy.sh restart"
	elif [ "2" == "$koolproxy_reboot" ]; then
		echo_date 开启插件间隔重启，每隔"$koolproxy_reboot_inter_hour"时，自动重启插件...
		cru a koolproxy_reboot "* */$koolproxy_reboot_inter_hour * * * /bin/sh $KP_DIR/koolproxy.sh restart"
	fi
}

remove_reboot_job(){
	jobexist=`cru l|grep koolproxy_reboot`
	# kill crontab job
	if [ -n "$jobexist" ];then
		echo_date 关闭插件定时重启...
		sed -i '/koolproxy_reboot/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}

load_module(){
	xt=`lsmod | grep xt_set`
	OS=$(uname -r)
	if [ -f /lib/modules/${OS}/kernel/net/netfilter/xt_set.ko ] && [ -z "$xt" ];then
		echo_date "加载内核模块！"
		insmod ip_set
		insmod ip_set_bitmap_ip
		insmod ip_set_bitmap_ipmac
		insmod ip_set_bitmap_port
		insmod ip_set_hash_ip
		insmod ip_set_hash_ipport
		insmod ip_set_hash_ipportip
		insmod ip_set_hash_ipportnet
		insmod ip_set_hash_net
		insmod ip_set_hash_netport
		insmod ip_set_list_set
		insmod xt_set
	fi
}

creat_ipset(){
	echo_date 创建ipset名单
	# Load ipset netfilter kernel modules and kernel modules
	ipset -! create white_kp_list nethash
	ipset -! create black_koolproxy iphash
}

add_white_black_ip(){
	echo_date 添加ipset名单
	ip_lan="0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.168.0.0/16 224.0.0.0/4 240.0.0.0/4"
	for ip in $ip_lan
	do
		ipset -A white_kp_list $ip >/dev/null 2>&1

	done
	ipset -A black_koolproxy 110.110.110.110 >/dev/null 2>&1
}

get_mode_name() {
	case "$1" in
		0)
			echo "不过滤"
		;;
		1)
			echo "http模式"
		;;
		2)
			echo "http + https"
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
	iptables -t nat -S | grep -E "KOOLPROXY|KP_HTTP|KP_HTTPS" | sed 's/-A/iptables -t nat -D/g'|sed 1,3d > clean.sh && chmod 777 clean.sh && ./clean.sh && rm clean.sh
	iptables -t nat -X KOOLPROXY > /dev/null 2>&1
	iptables -t nat -X KP_HTTP > /dev/null 2>&1
	iptables -t nat -X KP_HTTPS > /dev/null 2>&1
	ipset -F black_koolproxy > /dev/null 2>&1 && ipset -X black_koolproxy > /dev/null 2>&1
	ipset -F white_kp_list > /dev/null 2>&1 && ipset -X white_kp_list > /dev/null 2>&1
}

get_acl_para(){
	echo `dbus get koolproxy_acl_list|sed 's/>/\n/g'|sed '/^$/d'|awk NR==$1{print}|cut -d "<" -f "$2"`
}

lan_acess_control(){
	# lan access control
	[ -z "$koolproxy_acl_default" ] && koolproxy_acl_default=1
	acl_nu=`dbus get koolproxy_acl_list|sed 's/>/\n/g'|sed '/^$/d'|sed '/^ /d'|wc -l`
	if [ -n "$acl_nu" ]; then
		min="1"
		max="$acl_nu"
		while [ $min -le $max ]
		do
			#echo_date $min $max
			ipaddr=`get_acl_para $min 1`
			mac=`get_acl_para $min 2`
			proxy_name=`get_acl_para $min 3`
			proxy_mode=`get_acl_para $min 4`
		
			[ "$koolproxy_acl_method" == "1" ] && echo_date 加载ACL规则：【$ipaddr】【$mac】模式为：$(get_mode_name $proxy_mode)
			[ "$koolproxy_acl_method" == "2" ] && mac="" && echo_date 加载ACL规则：【$ipaddr】模式为：$(get_mode_name $proxy_mode)
			[ "$koolproxy_acl_method" == "3" ] && ipaddr="" && echo_date 加载ACL规则：【$mac】模式为：$(get_mode_name $proxy_mode)
			#echo iptables -t nat -A KOOLPROXY $(factor $ipaddr "-s") $(factor $mac "-m mac --mac-source") -p tcp $(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
			iptables -t nat -A KOOLPROXY $(factor $ipaddr "-s") $(factor $mac "-m mac --mac-source") -p tcp $(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
		min=`expr $min + 1`
		done
		echo_date 加载ACL规则：其余主机模式为：$(get_mode_name $koolproxy_acl_default)
		
	else
		echo_date 加载ACL规则：所有模式为：$(get_mode_name $koolproxy_acl_default)
	fi

}

load_nat(){
	nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v WANPREROUTING|grep -v destination)
	i=120
	# laod nat rules
	until [ -n "$nat_ready" ]
	do
	    i=$(($i-1))
	    if [ "$i" -lt 1 ];then
	        echo_date "Could not load nat rules!"
	        sh $SOFT_DIR/ss/stop.sh
	        exit
	    fi
	    sleep 1
	done
	
	echo_date 加载nat规则！
	#----------------------BASIC RULES---------------------
	echo_date 写入iptables规则到nat表中...
	# 创建KOOLPROXY nat rule
	iptables -t nat -N KOOLPROXY
	# 局域网地址不走KP
	iptables -t nat -A KOOLPROXY -m set --match-set white_kp_list dst -j RETURN
	#  生成对应CHAIN
	iptables -t nat -N KP_HTTP
	iptables -t nat -A KP_HTTP -p tcp -m multiport --dport 80,82,8080 -j REDIRECT --to-ports 3000
	iptables -t nat -N KP_HTTPS
	iptables -t nat -A KP_HTTPS -p tcp -m multiport --dport 80,82,443,8080 -j REDIRECT --to-ports 3000
	# 局域网控制
	lan_acess_control
	# 剩余流量转发到缺省规则定义的链中
	iptables -t nat -A KOOLPROXY -p tcp -j $(get_action_chain $koolproxy_acl_default)
	# 重定所有流量到 KOOLPROXY
	# 全局模式和视频模式
	[ "$koolproxy_mode" == "1" ] || [ "$koolproxy_mode" == "3" ] && iptables -t nat -I PREROUTING 2 -p tcp -j KOOLPROXY
	# ipset 黑名单模式
	[ "$koolproxy_mode" == "2" ] && iptables -t nat -I PREROUTING 2 -p tcp -m set --match-set black_koolproxy dst -j KOOLPROXY
}

dns_takeover(){
	ss_chromecast=`dbus get ss_basic_chromecast`
	lan_ipaddr=`nvram get lan_ipaddr`
	#chromecast=`iptables -t nat -L PREROUTING -v -n|grep "dpt:53"`
	chromecast_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|awk '{print $1}'`
	if [ "$koolproxy_mode" == "2" ]; then
		if [ -z "$chromecast_nu" ]; then
			echo_date 黑名单模式开启DNS劫持
			iptables -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
		else
			echo_date DNS劫持规则已经添加，跳过~
		fi
	else
		if [ "$ss_chromecast" != "1" ]; then
			if [ ! -z "$chromecast_nu" ]; then
				echo_date 全局过滤模式下删除DNS劫持
				iptables -t nat -D PREROUTING $chromecast_nu >/dev/null 2>&1
				echo_date done
				echo_date
			fi
		fi
	fi
}

detect_cert(){
	if [ ! -f $KP_DIR/data/private/ca.key.pem ]; then
		echo_date 检测到首次运行，开始生成koolproxy证书，用于https过滤！
		cd $KP_DIR/data && sh gen_ca.sh
	fi
}

get_rule_para(){
	echo `dbus get koolproxy_rule_list|sed 's/>/\n/g'|sed '/^$/d'|awk NR==$1{print}|cut -d "<" -f "$2"`
}


update_kp_rules(){
	mkdir -p /tmp/kpd
	rm -rf rm -rf /tmp/kpd/*
	# rule_nu=`dbus list koolproxy_rule_address_|sort -n -t "=" -k 2|cut -d "=" -f 1 | cut -d "_" -f 4`
	echo_date ================== 规则更新 =================
	echo_date
	rm -rf `ls -L $KP_DIR/data/*_*.dat` 
	rm -rf `ls -L $KP_DIR/data/*_*.txt`
	rule_nu=`dbus get koolproxy_rule_list|sed 's/>/\n/g'|sed '/^$/d'|sed '/^ /d'|wc -l`
	if [ "$rule_nu" != "0" ]; then
		min=1
		max=$rule_nu
		while [ $min -le $max ]
		do
			rule_load=`get_rule_para $min 1`
			rule_type=`get_rule_para $min 2`
			rule_addr=`get_rule_para $min 3`
			file_name=`echo $rule_addr|grep -Eo "\w+.dat|\w+.txt"`
			
			echo_date ① 检测$file_name 是否有更新...
			wget --no-check-certificate -q --timeout=3 --tries=2 $rule_addr -O /tmp/kpd/$min"_"$file_name
			if [ "$?" == "0" ]; then
				MD5_TMP=`md5sum /tmp/kpd/$min"_"$file_name| awk '{print $1}'`
				MD5_ORI=`md5sum $KP_DIR/rule_store/$min"_"$file_name| awk '{print $1}'`
				if [ ! -f $KP_DIR/rule_store/$min"_"$file_name ] || [ "$MD5_TMP"x != "$MD5_ORI"x ];then
					echo_date ② 更新$rule_addr
					mv -f /tmp/kpd/$min"_"$file_name $KP_DIR/rule_store/
				else
					echo_date ② 本地$file_name 已经是最新！
				fi
			else
				rm -rf rm -rf /tmp/kpd/*
				echo_date ① 检测规则错误！请检查你的网络到 $rule_addr 的连通性！
			fi
			[ "$rule_load" == "1" ] && \
			echo_date ③ 应用规则文件：$file_name && \
			ln -sf $KP_DIR/rule_store/$min"_"$file_name $KP_DIR/data/$min"_"$file_name
			echo_date 
		    min=`expr $min + 1`
		done  
	else
		echo_date ！！！没有加载任何规则！退出！！！
		dbus set koolproxy_enable=0
		exit
	fi
}

case $1 in
start)
	nvram set ks_nat="1"
	echo_date ================== koolproxy启用 =================
	[ ! -L "/tmp/upload/user.txt" ] && ln -sf $KSROOT/koolproxy/data/user.txt /tmp/upload/user.txt
	update_kp_rules
	detect_cert
	start_koolproxy
	add_ipset_conf && restart_dnsmasq
	load_module
	creat_ipset
	add_white_black_ip
	load_nat
	dns_takeover
	creat_start_up
	write_nat_start
	write_cron_job
	write_reboot_job
	# add_ss_event
	echo_date =================================================
	nvram set ks_nat="0"
	;;
restart)
	# now stop
	echo_date ================== 关闭 =================
	[ ! -L "/tmp/upload/user.txt" ] && ln -sf $KSROOT/koolproxy/data/user.txt /tmp/upload/user.txt
	remove_ss_event
	remove_reboot_job
	remove_ipset_conf
	remove_nat_start
	flush_nat
	stop_koolproxy
	kill_cron_job
	# now start
	echo_date ================== koolproxy启用 =================
	update_kp_rules
	detect_cert
	start_koolproxy
	add_ipset_conf && restart_dnsmasq
	load_module
	creat_ipset
	add_white_black_ip
	load_nat
	dns_takeover
	creat_start_up
	write_nat_start
	write_cron_job
	write_reboot_job
	add_ss_event
	echo_date koolproxy启用成功，请等待日志窗口自动关闭，页面会自动刷新...
	echo_date =================================================
	;;
stop)
	remove_ss_event
	remove_reboot_job
	remove_ipset_conf && restart_dnsmasq
	remove_nat_start
	flush_nat
	stop_koolproxy
	kill_cron_job
	#del_start_up
	;;
start_nat)
	flush_nat
	creat_ipset
	add_white_black_ip
	load_nat
	dns_takeover
	;;
esac
