#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export xiaomi_`

start_xiaomi(){
	cru d xiaomi
	cru a xiaomi "*/$xiaomi_interval * * * * /bin/sh $KSROOT/scripts/xiaomi_check.sh"
	# run once after submit
	sh $KSROOT/scripts/xiaomi_check.sh
	sleep 1
	# creat start_up file
	if [ ! -L "$KSROOT/init.d/S100Xiaomi.sh" ]; then 
		ln -sf $KSROOT/scripts/xiaomi_config.sh $KSROOT/init.d/S100Xiaomi.sh
	fi
}

stop_xiaomi(){
	cru d xiaomi
	cru d xiaomi_start
	cru d xiaomi_end
}

case $ACTION in
start)
	if [ "$xiaomi_auto_enable" == "1" ]; then
		logger "[小米风扇]: 启动小米风扇！"
		start_xiaomi
	fi
	;;
stop)
	stop_xiaomi
	;;
*)
	if [ "$xiaomi_auto_enable" == "1" ]; then
		start_xiaomi
   		http_response '插件已开启！页面将在3秒后刷新'
   	else
		stop_xiaomi
		http_response '插件已关闭！页面将在3秒后刷新'
	fi
	;;
esac
