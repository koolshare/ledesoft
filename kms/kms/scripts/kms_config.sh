#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

eval `dbus export kms`
CONFIG_FILE=/tmp/dnsmasq.d/kms.conf

start_kms(){
	$KSROOT/bin/vlmcsd
	echo "srv-host=_vlmcs._tcp.lan,`uname -n`.lan,1688,0,100" > $CONFIG_FILE
	/etc/init.d/dnsmasq restart
	[ ! -L "/etc/rc.d/S97kms.sh" ] && ln -sf $KSROOT/init.d/S97kms.sh /etc/rc.d/S97kms.sh
	#[ "$kms_firewall" == "1" ] && echo "sh $KSROOT/scripts/kms_config.sh start_nat" >> /etc/firewall.user
}

stop_kms(){
	killall vlmcsd
	rm $CONFIG_FILE
	/etc/init.d/dnsmasq restart
	rm -rf /etc/rc.d/S97kms.sh
	#sed -i '/kms_config.sh/d' /etc/firewall.user >/dev/null 2>&1
}

open_port(){
	if [ "$kms_firewall" == "1" ];then
		ifopen=`iptables -S -t filter | grep INPUT | grep dport |grep 1688`
		[ -z "$ifopen" ] && iptables -t filter -I INPUT -p tcp --dport 1688 -j ACCEPT > /dev/null 2>&1
	fi
}

close_port(){
	iptables -t filter -D INPUT -p tcp --dport 1688 -j ACCEPT > /dev/null 2>&1
}

write_firewall_start(){
	if [ "$kms_firewall" == "1" ];then
		echo_date 添加nat-start触发事件...
		uci -q batch <<-EOT
		  delete firewall.ks_kms
		  set firewall.ks_kms=include
		  set firewall.ks_kms.type=script
		  set firewall.ks_kms.path=/koolshare/scripts/kms_config.sh
		  set firewall.ks_kms.family=any
		  set firewall.ks_kms.reload=1
		  commit firewall
		EOT
	fi
}

remove_firewall_start(){
	echo_date 删除nat-start触发...
	uci -q batch <<-EOT
	  delete firewall.ks_kms
	  commit firewall
	EOT
}

# used by rc.d and firewall include
case $1 in
start)
	if [ "$kms_enable" == "1" ]; then
		logger "[软件中心]: 启动KMS！"
		start_kms
   		open_port
   		write_firewall_start
	else
		logger "[软件中心]: KMS未设置开机启动，跳过！"
	fi
	;;
stop)
	close_port
	stop_kms
	;;
*)
	if [ -z "$2" ];then
		close_port
		open_port
	fi
	;;
esac

# used by httpdb
case $2 in
start)
	if [ "$kms_enable" == "1" ]; then
		remove_firewall_start
		close_port
		stop_kms
		sleep 1
   		start_kms
   		open_port
   		write_firewall_start
   		http_response '服务已开启！页面将在3秒后刷新'
   	else
   		remove_firewall_start
   		close_port
		stop_kms
		http_response '服务已关闭！页面将在3秒后刷新'
	fi
	;;
esac
