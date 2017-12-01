#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export easyexplorer_`

check_folder(){
	[ ! -d "$easyexplorer_folder" ] && {
		mkdir -p "$easyexplorer_folder"
		[ "$?" -eq 0 ] && exit 0	
	}	
}

gen_config(){
	cat >/tmp/etc/easyexplorer.json<<EOF
{"username":"$easyexplorer_token","sharePath":"$easyexplorer_folder"}
EOF
}

start_easyexplorer(){
	#easyexplorer /tmp/etc/easyexplorer.json >/dev/null 2>&1 &
	easyexplorer -u "$easyexplorer_token" -share "$easyexplorer_folder" >/dev/null 2>&1 &
}

stop_easyexplorer(){
	killall easyexplorer
}

creat_start_up(){
	[ ! -L "/etc/rc.d/S99easyexplorer.sh" ] && ln -sf /koolshare/init.d/S88easyexplorer.sh /etc/rc.d/S99easyexplorer.sh
}

del_start_up(){
	rm -rf /etc/rc.d/S99easyexplorer.sh >/dev/null 2>&1
}

open_port(){
	iptables -I zone_wan_input 2 -p tcp -m tcp --dport 2300 -m comment --comment "softcenter: easyexplorer" -j ACCEPT >/dev/null 2>&1
}

close_port(){
	local port_exist=`iptables -L input_rule | grep -c easyexplorer`
	if [ ! -z "$port_exist" ];then
		until [ "$port_exist" = 0 ]
	do
		iptables -D zone_wan_input -p tcp -m tcp --dport 2300 -m comment --comment "softcenter: easyexplorer" -j ACCEPT >/dev/null 2>&1
		port_exist=`expr $port_exist - 1`
	done
	fi
}

write_nat_start(){
	uci -q batch <<-EOT
	  delete firewall.easyexplorer
	  set firewall.easyexplorer=include
	  set firewall.easyexplorer.type=script
	  set firewall.easyexplorer.path="/koolshare/scripts/easyexplorer_nat.sh"
	  set firewall.easyexplorer.family=any
	  set firewall.easyexplorer.reload=1
	  commit firewall
	EOT
}

remove_nat_start(){
	uci -q batch <<-EOT
	  delete firewall.easyexplorer
	  commit firewall
	EOT
}

case $1 in
port)
	open_port
	;;
*)
	if [ "$easyexplorer_enable" == "1" ]; then
		stop_easyexplorer
		sleep 1
		check_folder
		#gen_config
		start_easyexplorer
		creat_start_up
		open_port
		write_nat_start
		http_response '服务已开启！页面将在3秒后刷新'
	else
		stop_easyexplorer
		del_start_up
		remove_nat_start
		http_response '服务已关闭！页面将在3秒后刷新'
	fi
	;;
esac