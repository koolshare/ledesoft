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
	[ "$kms_firewall" == "1" ] && echo "sh $KSROOT/scripts/kms_config.sh start_nat" >> /etc/firewall.user
}

stop_kms(){
	killall vlmcsd
	rm $CONFIG_FILE
	/etc/init.d/dnsmasq restart
	rm -rf /etc/rc.d/S97kms.sh
	sed -i '/kms_config.sh/d' /etc/firewall.user >/dev/null 2>&1
}

open_port(){
	ifopen=`iptables -S -t filter | grep INPUT | grep dport |grep 1688`
	[ -z "$ifopen" ] && iptables -t filter -I INPUT -p tcp --dport 1688 -j ACCEPT > /dev/null 2>&1
}

close_port(){
	iptables -t filter -D INPUT -p tcp --dport 1688 -j ACCEPT > /dev/null 2>&1
}

case $ACTION in
start)
	# used by rc.d
	if [ "$kms_enable" == "1" ]; then
		logger "[软件中心]: 启动KMS！"
		start_kms
   		[ "$kms_firewall" == "1" ] && open_port
	else
		logger "[软件中心]: KMS未设置开机启动，跳过！"
	fi
	;;
stop)
	close_port
	stop_kms
	;;
start_nat)
	close_port
	[ "$kms_firewall" == "1" ] && open_port
	;;
*)
	# used by httpdb
	if [ "$kms_enable" == "1" ]; then
		close_port
		stop_kms
   		start_kms
   		[ "$kms_firewall" == "1" ] && open_port
   		http_response '服务已开启！页面将在3秒后刷新'
   	else
   		close_port
		stop_kms
		http_response '服务已关闭！页面将在3秒后刷新'
	fi
	;;
esac