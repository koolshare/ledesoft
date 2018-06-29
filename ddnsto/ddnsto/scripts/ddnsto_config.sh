#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export ddnsto_`

start_ddnsto(){
	ddnsto -u $ddnsto_token -d
}

stop_ddnsto(){
	killall ddnsto
}

creat_start_up(){
	[ ! -L "/etc/rc.d/S88ddnsto.sh" ] && ln -sf /koolshare/init.d/S88ddnsto.sh /etc/rc.d/S88ddnsto.sh
}

del_start_up(){
	rm -rf /etc/rc.d/S88ddnsto.sh >/dev/null 2>&1
}


if [ "$ddnsto_enable" == "1" ]; then
	del_start_up
	stop_ddnsto
	sleep 1
	start_ddnsto
	creat_start_up
   	http_response '服务已开启！页面将在3秒后刷新'
else
	stop_ddnsto
	del_start_up
	http_response '服务已关闭！页面将在3秒后刷新'
fi

