#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export pppoerelay_`

start_pppoerelay(){
	if [ -n "$pppoerelay_dev" ]; then
		local landev brlan
		brlan=$(uci get network.lan.type)
		if [ "$brlan" == "bridge" ]; then
			landev="br-lan"
		else
			landev=$(uci get network.lan.ifname)
		fi
		pppoe-relay -F -S $pppoerelay_dev -C $landev -n $pppoerelay_sesssions -i $pppoerelay_time&
	fi
}

stop_pppoerelay(){
	killall -q -9 pppoe-relay
}

creat_start_up(){
	[ ! -L "/etc/rc.d/S97pppoerelay.sh" ] && ln -sf /koolshare/init.d/S97pppoerelay.sh /etc/rc.d/S97pppoerelay.sh
}

if [ "$pppoerelay_enable" == "1" ]; then
	stop_pppoerelay
	sleep 1
	start_pppoerelay
	creat_start_up
   	http_response '服务已开启！页面将在3秒后刷新'
else
	stop_pppoerelay
	http_response '服务已关闭！页面将在3秒后刷新'
fi

