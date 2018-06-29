#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export dmz_`
lan_ip=$(uci get network.lan.ipaddr)
wan_ip=$(ubus call network.interface.wan status | grep \"address\" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')

start_dmz(){
	[ -z "$wan_ip" ] || [ -z "$lan_ip" ] || [ -z "$dmz_ip" ] && exit
	iptables -t nat -A zone_lan_postrouting -s $lan_ip/24 -d $dmz_ip/32 -p tcp -m tcp --dport 1:65535 -m comment --comment "DMZ: Forward (reflection)" -j SNAT --to-source $lan_ip
	iptables -t nat -A zone_lan_postrouting -s $lan_ip/24 -d $dmz_ip/32 -p udp -m udp --dport 1:65535 -m comment --comment "DMZ: Forward (reflection)" -j SNAT --to-source $lan_ip
	iptables -t nat -A zone_lan_prerouting -s $lan_ip/24 -d $wan_ip/32 -p tcp -m tcp --dport 1:65535 -m comment --comment "DMZ: Forward (reflection)" -j DNAT --to-destination $dmz_ip:1-65535
	iptables -t nat -A zone_lan_prerouting -s $lan_ip/24 -d $wan_ip/32 -p udp -m udp --dport 1:65535 -m comment --comment "DMZ: Forward (reflection)" -j DNAT --to-destination $dmz_ip:1-65535
	iptables -t nat -A zone_wan_prerouting -p tcp -m tcp --dport 1:65535 -m comment --comment "DMZ: Forward" -j DNAT --to-destination $dmz_ip:1-65535
	iptables -t nat -A zone_wan_prerouting -p udp -m udp --dport 1:65535 -m comment --comment "DMZ: Forward" -j DNAT --to-destination $dmz_ip:1-65535
}

stop_dmz(){
	iptables -t nat -D zone_lan_postrouting -s $lan_ip/24 -d $dmz_ip/32 -p tcp -m tcp --dport 1:65535 -m comment --comment "DMZ: Forward (reflection)" -j SNAT --to-source $lan_ip > /dev/null
	iptables -t nat -D zone_lan_postrouting -s $lan_ip/24 -d $dmz_ip/32 -p udp -m udp --dport 1:65535 -m comment --comment "DMZ: Forward (reflection)" -j SNAT --to-source $lan_ip > /dev/null
	iptables -t nat -D zone_lan_prerouting -s $lan_ip/24 -d $wan_ip/32 -p tcp -m tcp --dport 1:65535 -m comment --comment "DMZ: Forward (reflection)" -j DNAT --to-destination $dmz_ip:1-65535 > /dev/null
	iptables -t nat -D zone_lan_prerouting -s $lan_ip/24 -d $wan_ip/32 -p udp -m udp --dport 1:65535 -m comment --comment "DMZ: Forward (reflection)" -j DNAT --to-destination $dmz_ip:1-65535 > /dev/null
	iptables -t nat -D zone_wan_prerouting -p tcp -m tcp --dport 1:65535 -m comment --comment "DMZ: Forward" -j DNAT --to-destination $dmz_ip:1-65535 > /dev/null
	iptables -t nat -D zone_wan_prerouting -p udp -m udp --dport 1:65535 -m comment --comment "DMZ: Forward" -j DNAT --to-destination $dmz_ip:1-65535 > /dev/null
}

creat_start_up(){
	[ ! -L "/etc/rc.d/S90dmz.sh" ] && ln -sf /koolshare/init.d/S90dmz.sh /etc/rc.d/S90dmz.sh
}

del_start_up(){
	rm -rf /etc/rc.d/S90dmz.sh >/dev/null 2>&1
}

write_nat_start(){
	echo_date 添加nat-start触发事件...
	uci -q batch <<-EOT
	  delete firewall.ks_dmz
	  set firewall.ks_dmz=include
	  set firewall.ks_dmz.type=script
	  set firewall.ks_dmz.path=/koolshare/scripts/dmz_config.sh
	  set firewall.ks_dmz.family=any
	  set firewall.ks_dmz.reload=1
	  commit firewall
	EOT
}

remove_nat_start(){
	echo_date 删除nat-start触发...
	uci -q batch <<-EOT
	  delete firewall.ks_dmz
	  commit firewall
	EOT
}

if [ "$dmz_enable" == "1" ]; then
	del_start_up
	remove_nat_start
	stop_dmz
	sleep 1
	start_dmz
	creat_start_up
	write_nat_start
   	http_response '服务已开启！页面将在3秒后刷新'
else
	stop_dmz
	del_start_up
	remove_nat_start
	http_response '服务已关闭！页面将在3秒后刷新'
fi

