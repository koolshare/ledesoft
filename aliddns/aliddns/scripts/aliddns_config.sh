#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export aliddns_`

start_aliddns(){
    cru d aliddns
    cru a aliddns "*/$aliddns_interval * * * * /bin/sh $KSROOT/scripts/aliddns_update.sh"
    # run once after submit
	sh $KSROOT/scripts/aliddns_update.sh
	sleep 1
	# creat start_up file
	if [ ! -L "$KSROOT/init.d/S98Aliddns.sh" ]; then 
		ln -sf $KSROOT/scripts/aliddns_config.sh $KSROOT/init.d/S98Aliddns.sh
	fi
}

stop_aliddns(){
    cru d aliddns
    dbus set aliddns_last_act="<font color=red>服务未开启</font>"
}

case $ACTION in
start)
	if [ "$aliddns_enable" == "1" ]; then
		logger "[软件中心]: 启动ALIDDNS！"
		start_aliddns
	else
		logger "[软件中心]: ALIDDNS未设置开机启动，跳过！"
	fi
	;;
stop)
	stop_aliddns
	;;
*)
	if [ "$aliddns_enable" == "1" ]; then
		start_aliddns
   		http_response '服务已开启！页面将在3秒后刷新'
   	else
		stop_aliddns
		http_response '服务已关闭！页面将在3秒后刷新'
	fi
	;;
esac
