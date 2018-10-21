#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export webd_`

start_webd(){
	/koolshare/bin/webd -l $webd_port -w $webd_dir >/dev/null 2>&1 &
	[ ! -L "/etc/rc.d/S99webd.sh" ] && ln -sf /koolshare/init.d/S99webd.sh /etc/rc.d/S99webd.sh
}

stop_webd(){
	killall webd >/dev/null 2>&1
}

open_port(){
	iptables -I zone_wan_input 2 -p tcp -m tcp --dport $webd_port -m comment --comment "softcenter: webd" -j ACCEPT >/dev/null 2>&1
}

close_port(){
	local port_exist port_nu
	port_exist=`iptables -L zone_wan_input | grep -c webd`
	if [ "$port_exist" -ne 0 ];then
		for i in `seq $port_exist`
		do
			port_nu=`iptables -L zone_wan_input -v -n --line-numbers|grep "webd"|awk '{print $1}'|head -1`
			iptables -D zone_wan_input $port_nu >/dev/null 2>&1
		done
	fi
}

stop_all(){
	close_port
	stop_webd
}

start_all(){
	if [ "$webd_enable" == "1" ];then
		stop_all
		start_webd
		open_port
	else
        stop_all
    fi
}

case $1 in
stop)
    stop_all
	;;
*)
	start_all
	http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'
	;;
esac
