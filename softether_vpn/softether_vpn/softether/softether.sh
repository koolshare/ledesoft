#! /bin/sh
# 导入skipd数据
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export softether`
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

creat_start_up(){
	rm -rf $KSROOT/init.d/S96SoftEther.sh
	ln -sf $KSROOT/scripts/softether_config.sh $KSROOT/init.d/S96SoftEther.sh
	ln -sf $KSROOT/softether/softether.sh $KSROOT/init.d/N96SoftEther.sh
}

open_close_port(){
	[ -f "$KSROOT/softether/vpn_server.config" ] && openvpn_port=`cat $KSROOT/softether/vpn_server.config | grep OpenVPN_UdpPortList | awk -F " " '{print $3}'` || openvpn_port=1194
	[ -z "$openvpn_port" ] && openvpn_port=1194
	# flush first
	iptables -D INPUT -p udp --dport 500 -j ACCEPT
	iptables -D INPUT -p udp --dport 1701 -j ACCEPT
	iptables -D INPUT -p udp --dport 4500 -j ACCEPT
	iptables -D INPUT -p tcp --dport $openvpn_port -j ACCEPT
	iptables -D INPUT -p udp --dport $openvpn_port -j ACCEPT
	iptables -D INPUT -p tcp --dport 443 -j ACCEPT
	iptables -D INPUT -p tcp --dport 5555 -j ACCEPT
	iptables -D INPUT -p tcp --dport 8888 -j ACCEPT
	iptables -D INPUT -p tcp --dport 992 -j ACCEPT
	# add	
	if [ "$softether_enable" == "1" ] && [ "$softether_l2tp" == "1" ];then
		# l2tp
		iptables -I INPUT -p udp --dport 500 -j ACCEPT
		iptables -I INPUT -p udp --dport 1701 -j ACCEPT
		iptables -I INPUT -p udp --dport 4500 -j ACCEPT
	fi
	if [ "$softether_enable" == "1" ] && [ "$softether_openvpn" == "1" ];then
		# openvpn
		iptables -I INPUT -p tcp --dport "$openvpn_port" -j ACCEPT
		iptables -I INPUT -p udp --dport "$openvpn_port" -j ACCEPT
	fi
	if [ "$softether_enable" == "1" ] && [ "$softether_sstp" == "1" ];then
		# sstp
		iptables -I INPUT -p tcp --dport 443 -j ACCEPT
	fi
	if [ "$softether_enable" == "1" ];then
		# other
		iptables -I INPUT -p tcp --dport 5555 -j ACCEPT
		iptables -I INPUT -p tcp --dport 8888 -j ACCEPT
		iptables -I INPUT -p tcp --dport 992 -j ACCEPT
	fi
}

case $1 in
restart)
	/usr/bin/env LANG=en_US.UTF-8 $KSROOT/softether/vpnserver stop >/dev/null 2>&1
	pid=`pidof vpnserver`
	if [ ! -z "$pid" ];then
		echo_date "关闭vpnserver主进程..."
		kill -9 "$pid"
	fi
	#open_close_port
	mod=`lsmod |grep tun`
	if [ -z "$mod" ];then
		echo_date "加载tun模块"
		modprobe tun
	fi
	echo_date "开启SoftetherVPN进程..." 
	/usr/bin/env LANG=en_US.UTF-8 $KSROOT/softether/vpnserver start >/dev/null 2>&1

	echo_date "等待虚拟网卡设置...." 
	echo_date "如果你第一次开启此软件，此处会等待15分钟，直到你在控制台中设置了新的本地网桥。" 
	echo_date "如果超过15分钟后仍然没有设置新的本地网桥，你以后可以随时进行设置，但是设置后需要重新提交一次插件。" 
	i=900
	until [ ! -z "$tap" ]
	do
	    i=$(($i-1))
		tap=`ifconfig | grep tap_ | awk '{print $1}'`
	    if [ "$i" -lt 1 ];then
	        echo_date "设置本地网桥超时，将不再继续运行插件，但是会保留SoftetherVPN主进程" 
	        exit
	    fi
	    echo_date "$i" 秒...
	    sleep 1
	done
	echo_date "打开相应端口..."
	open_close_port
	echo_date "桥接虚拟网卡..."
	brctl addif br0 $tap
	echo_date "设置dnsmasq..."
	echo interface=tap_vpn > /jffs/etc/dnsmasq.d/softether.conf
	echo_date "重启dnsmasq..."
	service dnsmasq restart >/dev/null 2>&1
	echo_date "创建开机启动..."
	creat_start_up
	echo_date "插件运行完毕！"
	;;
stop)
	echo_date "停止vpsnserver主进程..."
	/usr/bin/env LANG=en_US.UTF-8 $KSROOT/softether/vpnserver stop  >/dev/null 2>&1
	echo_date "关闭相应端口..."
	open_close_port
	echo_date "删除dnsmasq设置..."
	rm -rf /jffs/etc/dnsmasq.d/softether.conf
	echo_date "重启dnsmasq..."
	service dnsmasq restart >/dev/null 2>&1
	echo_date "删除开机启动..."
	rm -rf $KSROOT/init.d/S96SoftEther.sh
	rm -rf $KSROOT/init.d/N96SoftEther.sh
	echo_date "插件关闭成功！"
	;;
start_nat)
	open_close_port
	;;
esac
