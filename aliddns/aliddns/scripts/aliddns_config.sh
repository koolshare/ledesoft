#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export aliddns_`

start_aliddns(){
    sed -i '/aliddns_update/d' /etc/crontabs/root >/dev/null 2>&1
    echo "*/$aliddns_interval * * * * $KSROOT/scripts/aliddns_update.sh" >> /etc/crontabs/root
    # run once after submit
	sh $KSROOT/scripts/aliddns_update.sh
	sleep 1
	# creat start_up file
	if [ ! -L "/etc/rc.d/S98Aliddns.sh" ]; then 
		ln -sf $KSROOT/init.d/S98aliddns.sh /etc/rc.d/S98Aliddns.sh
	fi
}

stop_aliddns(){
    sed -i '/aliddns_update/d' /etc/crontabs/root >/dev/null 2>&1
    dbus set aliddns_last_act="<font color=red>服务未开启</font>"
	rm -rf /etc/rc.d/S98Aliddns.sh
}

start_wanup(){
    cat > /etc/hotplug.d/iface/98-aliddns <<-EOF
		#!/bin/sh
		case "$ACTION" in
		ifup)
		sh $KSROOT/scripts/aliddns_update.sh
		;;
		esac
EOF
}

stop_wanup(){
    rm -rf /etc/hotplug.d/iface/98-aliddns >/dev/null 2>&1
}

case $ACTION in
start)
	if [ "$aliddns_enable" == "1" ]; then
		logger "[软件中心]: 启动ALIDDNS！"
		start_wanup
		start_aliddns
	else
		logger "[软件中心]: ALIDDNS未设置开机启动，跳过！"
	fi
	;;
stop)
	stop_wanup
	stop_aliddns
	;;
*)
	if [ "$aliddns_enable" == "1" ]; then
		start_aliddns
		start_wanup
   		http_response '服务已开启！页面将在3秒后刷新'
   	else
		stop_wanup
		stop_aliddns
		http_response '服务已关闭！页面将在3秒后刷新'
	fi
	;;
esac
