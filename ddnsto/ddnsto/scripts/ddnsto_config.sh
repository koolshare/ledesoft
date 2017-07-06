#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export ddnsto_`

start_ddnsto(){
	ddnsto -u $ddnsto_token -d
}

stop_ddnsto(){
	killall ddnsto
}

case $1 in
start)
	if [ "$ddnsto_enable" == "1" ]; then
		logger "[软件中心]: 启动ddnsto！"
		start_ddnsto
	else
		logger "[软件中心]: ddnsto未设置开机启动，跳过！"
	fi
	;;
stop)
	stop_ddnsto
	;;
*)
	if [ "$ddnsto_enable" == "1" ]; then
		stop_ddnsto
		start_ddnsto
   		http_response '服务已开启！页面将在3秒后刷新'
   	else
		stop_ddnsto
		http_response '服务已关闭！页面将在3秒后刷新'
	fi
	;;
esac
