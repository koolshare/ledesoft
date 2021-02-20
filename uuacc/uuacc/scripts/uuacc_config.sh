#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export uuacc_`

start_uuacc(){
	/bin/sh /koolshare/uu//uuplugin_monitor.sh &
}

stop_uuacc(){
	uuplugin_monitor=`ps|grep "uuplugin_monitor.sh"|grep -v grep|awk '{print $1}'| xargs kill >/dev/null 2>&1`
	$uuplugin_monitor
	killall uuplugin >/dev/null 2>&1
}

creat_start_up(){
	[ ! -L "/etc/rc.d/S99uuacc.sh" ] && ln -sf /koolshare/init.d/S99uuacc.sh /etc/rc.d/S99uuacc.sh
}

del_start_up(){
	rm -rf /etc/rc.d/S99uuacc.sh >/dev/null 2>&1
}


if [ "$uuacc_enable" == "1" ]; then
	del_start_up
	stop_uuacc
	sleep 1
	start_uuacc
	creat_start_up
  http_response '服务已开启！页面将在3秒后刷新'
else
	stop_uuacc
	del_start_up
	http_response '服务已关闭！页面将在3秒后刷新'
fi

