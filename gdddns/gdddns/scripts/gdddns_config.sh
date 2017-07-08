#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export gdddns_`

start_gdddns(){
    cru d gdddns
    cru a gdddns "*/$gdddns_interval * * * * /bin/sh $KSROOT/scripts/gdddns_update.sh"
    # run once after submit
	sh $KSROOT/scripts/gdddns_update.sh
	sleep 1
	# creat start_up file
	if [ ! -L "$KSROOT/init.d/S98gdddns.sh" ]; then 
		ln -sf $KSROOT/scripts/gdddns_config.sh $KSROOT/init.d/S98gdddns.sh
	fi
}

stop_gdddns(){
    cru d gdddns
    dbus set gdddns_last_act="<font color=red>服务未开启</font>"
}

case $ACTION in
start)
	if [ "$gdddns_enable" == "1" ]; then
		logger "[软件中心]: 启动 Godaddy DDNS！"
		start_gdddns
	else
		logger "[软件中心]: Godaddy DDNS 未设置开机启动，跳过！"
	fi
	;;
stop)
	stop_gdddns
	;;
*)
	if [ "$gdddns_enable" == "1" ]; then
		start_gdddns
   		http_response '服务已开启！页面将在3秒后刷新'
   	else
		stop_gdddns
		http_response '服务已关闭！页面将在3秒后刷新'
	fi
	;;
esac

