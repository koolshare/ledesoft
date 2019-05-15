#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export easyexplorer_`

check_folder(){
	[ ! -d "$easyexplorer_folder" ] && {
		mkdir -p "$easyexplorer_folder"
		[ "$?" -eq 0 ] && exit 0	
	}	
}

check_dlna(){
	[ "$easyexplorer_dlna" == "1" -a ! -f "/usr/bin/video_mux" ] && {
		wget --no-check-certificate --timeout=8 --tries=2 -O - https://ledesoft.ngrok.wang/easyexplorer/module/video_mux > /tmp/video_mux
		[ "$?" -eq 0 ] && mv /tmp/video_mux /usr/bin/video_mux && chmod a+x /usr/bin/video_mux
	}	
}

gen_config(){
	cat >/tmp/etc/easyexplorer.json<<EOF
{"username":"$easyexplorer_token","sharePath":"$easyexplorer_folder"}
EOF
}

start_easyexplorer(){
	token=`echo $easyexplorer_token | sed s/[[:space:]]//g`
	start-stop-daemon -S -b -q -x $KSROOT/bin/easyexplorer -- -u "$token" -share "$easyexplorer_folder" -c /tmp >/dev/null
}

stop_easyexplorer(){
	killall easyexplorer
}

creat_start_up(){
	[ ! -L "/etc/rc.d/S99easyexplorer.sh" ] && ln -sf /koolshare/init.d/S99easyexplorer.sh /etc/rc.d/S99easyexplorer.sh
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
		check_dlna
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