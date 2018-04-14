#! /bin/sh
# 导入skipd数据
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export softether`
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
LOCK_FILE=/var/lock/softether.lock
[ -f "$KSROOT/softether/vpn_server.config" ] && openvpn_port=`cat $KSROOT/softether/vpn_server.config | grep OpenVPN_UdpPortList | awk -F " " '{print $3}'` || openvpn_port=1194
[ -z "$openvpn_port" ] && openvpn_port=1194

creat_start_up(){
	[ ! -L "/etc/rc.d/S96softether.sh" ] && ln -sf $KSROOT/init.d/S96softether.sh /etc/rc.d/S96softether.sh
}

write_nat_start(){
	echo_date 添加nat-start触发事件...
	uci -q batch <<-EOT
	  delete firewall.ks_softether
	  set firewall.ks_softether=include
	  set firewall.ks_softether.type=script
	  set firewall.ks_softether.path=/koolshare/softether/softether.sh
	  set firewall.ks_softether.family=any
	  set firewall.ks_softether.reload=1
	  commit firewall
	EOT
}

remove_nat_start(){
	echo_date 删除nat-start触发...
	uci -q batch <<-EOT
	  delete firewall.ks_softether
	  commit firewall
	EOT
}

open_close_port(){
	# flush first
	iptables -D INPUT -p udp --dport 500 -j ACCEPT > /dev/null 2>&1
	iptables -D INPUT -p udp --dport 1701 -j ACCEPT > /dev/null 2>&1
	iptables -D INPUT -p udp --dport 4500 -j ACCEPT > /dev/null 2>&1
	iptables -D INPUT -p tcp --dport $openvpn_port -j ACCEPT > /dev/null 2>&1
	iptables -D INPUT -p udp --dport $openvpn_port -j ACCEPT > /dev/null 2>&1
	iptables -D INPUT -p tcp --dport 443 -j ACCEPT > /dev/null 2>&1
	iptables -D INPUT -p tcp --dport 5555 -j ACCEPT > /dev/null 2>&1
	iptables -D INPUT -p tcp --dport 8888 -j ACCEPT > /dev/null 2>&1
	iptables -D INPUT -p tcp --dport 992 -j ACCEPT > /dev/null 2>&1
	sleep 2
	# add	
	if [ "$softether_enable" == "1" ] && [ "$softether_l2tp" == "1" ];then
		# l2tp
		iptables -I INPUT -p udp --dport 500 -j ACCEPT > /dev/null 2>&1
		iptables -I INPUT -p udp --dport 1701 -j ACCEPT > /dev/null 2>&1
		iptables -I INPUT -p udp --dport 4500 -j ACCEPT > /dev/null 2>&1
	fi
	if [ "$softether_enable" == "1" ] && [ "$softether_openvpn" == "1" ];then
		# openvpn
		iptables -I INPUT -p tcp --dport "$openvpn_port" -j ACCEPT > /dev/null 2>&1
		iptables -I INPUT -p udp --dport "$openvpn_port" -j ACCEPT > /dev/null 2>&1
	fi
	if [ "$softether_enable" == "1" ] && [ "$softether_sstp" == "1" ];then
		# sstp
		iptables -I INPUT -p tcp --dport 443 -j ACCEPT > /dev/null 2>&1
	fi
	if [ "$softether_enable" == "1" ];then
		# other
		iptables -I INPUT -p tcp --dport 5555 -j ACCEPT > /dev/null 2>&1
		iptables -I INPUT -p tcp --dport 8888 -j ACCEPT > /dev/null 2>&1
		iptables -I INPUT -p tcp --dport 992 -j ACCEPT > /dev/null 2>&1
	fi
}

case $1 in
restart)
	{
		flock -x 1000
		{
			/usr/bin/env LANG=en_US.UTF-8 $KSROOT/softether/vpnserver stop >/dev/null 2>&1
			remove_nat_start
			pid=`pidof vpnserver`
			if [ ! -z "$pid" ];then
				echo_date "关闭vpnserver主进程..."
				kill -9 "$pid"
			fi
			#open_close_port
			mod=`lsmod |grep -w tun`
			if [ -z "$mod" ];then
				echo_date "加载tun模块"
				modprobe tun
			fi
			echo_date "开启SoftetherVPN进程..." 
			/usr/bin/env LANG=en_US.UTF-8 $KSROOT/softether/vpnserver start >/dev/null 2>&1

			echo_date "等待虚拟网卡设置...." 
			echo_date "如果你第一次开启此软件，此处会等待15分钟，直到你在控制台中设置了新的本地网桥；" 
			echo_date "本地网桥设置请参考【设置教程】第10步；" 
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
			echo_date "将虚拟网卡$tap桥接到br-lan..."
			brctl addif br-lan $tap
			creat_start_up
			echo_date "创建防火墙启动..."
			write_nat_start
			echo_date "插件运行完毕！"
		}
		flock -u 1000
	} 1000<>"$LOCK_FILE"
	;;
stop)
	{
		flock -x 1000
		{
			
			echo_date "停止vpsnserver主进程..."
			/usr/bin/env LANG=en_US.UTF-8 $KSROOT/softether/vpnserver stop  >/dev/null 2>&1
			echo_date "关闭相应端口..."
			open_close_port
			echo_date "删除防火墙启动..."
			remove_nat_start
			echo_date "插件关闭成功！"
		}
		flock -u 1000
	} 1000<>"$LOCK_FILE"
	;;
*)
	{
		flock -x 1000
		{
			open_close_port
		}
		flock -u 1000
	} 1000<>"$LOCK_FILE"
	;;
esac
