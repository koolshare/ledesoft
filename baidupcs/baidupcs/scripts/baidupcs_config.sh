#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export baidupcs_`

start_baidupcs(){
	$KSROOT/bin/baidupcs web --port $baidupcs_port >/dev/null 2>&1 &
}

stop_baidupcs(){
	killall baidupcs
}

creat_start_up(){
	[ ! -L "/etc/rc.d/S99baidupcs.sh" ] && ln -sf /koolshare/init.d/S99baidupcs.sh /etc/rc.d/S99baidupcs.sh
}

if [ "$baidupcs_enable" == "1" ]; then
	stop_baidupcs
	sleep 1
	start_baidupcs
	creat_start_up
	http_response '服务已开启！页面将在3秒后刷新'
else
	stop_baidupcs
	http_response '服务已关闭！页面将在3秒后刷新'
fi
