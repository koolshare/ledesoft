#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export udp2raw_`

get_iptables_mode(){
	case "$1" in
		0)
			echo "-a"
		;;
		1)
			echo "-g"
		;;
	esac
}

get_keep_mode(){
	case "$1" in
		0)
			echo ""
		;;
		1)
			echo "--keep-rule"
		;;
	esac
}

get_lower_mode(){
	case "$1" in
		0)
			echo ""
		;;
		1)
			echo "--lower-level"
		;;
	esac
}

start_udp2raw(){
	nohup udp2raw -c -l 0.0.0.0:$udp2raw_local -r $udp2raw_server:$udp2raw_port -k "\"$udp2raw_passwd\"" $(get_iptables_mode $udp2raw_iptables) $(get_keep_mode $udp2raw_keep) $(get_lower_mode $udp2raw_lower) --cipher-mode $udp2raw_cipher --auth-mode $udp2raw_auth --raw-mode $udp2raw_mode $udp2raw_custom & >/dev/null 2>&1
}

stop_udp2raw(){
	killall -q -9 udp2raw
}

creat_start_up(){
	[ ! -L "/etc/rc.d/S99udp2raw.sh" ] && ln -sf /koolshare/init.d/S99udp2raw.sh /etc/rc.d/S99udp2raw.sh
}

del_start_up(){
	rm -rf /etc/rc.d/S99udp2raw.sh >/dev/null 2>&1
}


if [ "$udp2raw_enable" == "1" ]; then
	del_start_up
	stop_udp2raw
	sleep 1
	start_udp2raw
	creat_start_up
   	http_response '服务已开启！页面将在3秒后刷新'
else
	stop_udp2raw
	del_start_up
	http_response '服务已关闭！页面将在3秒后刷新'
fi

