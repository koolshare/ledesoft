#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export gdddns_`

start_gdddns(){
    sed -i '/gdddns_update.sh/d' /etc/crontabs/root >/dev/null 2>&1
    cru a gdddns "*/$gdddns_interval * * * * $KSROOT/scripts/gdddns_update.sh"
    # run once after submit
	sh $KSROOT/scripts/gdddns_update.sh
	sleep 1
	# creat start_up file
	if [ ! -L "/etc/rc.d/S98gdddns.sh" ]; then 
		ln -sf $KSROOT/init.d/S98gddns.sh /etc/rc.d/S98gdddns.sh
	fi
}

stop_gdddns(){
    sed -i '/gdddns_update.sh/d' /etc/crontabs/root >/dev/null 2>&1
    dbus set gdddns_last_act="<font color=red>服务未开启</font>"
	rm -rf /etc/rc.d/S98gdddns.sh
}

start_wanup(){
    cat > /etc/hotplug.d/iface/98-gdddns <<-EOF
		#!/bin/sh
		case "$ACTION" in
		ifup)
		sh $KSROOT/scripts/gdddns_update.sh
		;;
		esac
EOF
}

stop_wanup(){
    rm -rf /etc/hotplug.d/iface/98-gdddns >/dev/null 2>&1
}

case $ACTION in
start)
	if [ "$gdddns_enable" == "1" ]; then
		logger "[软件中心]: 启动 Godaddy DDNS！"
		start_wanup
		start_gdddns
	else
		logger "[软件中心]: Godaddy DDNS 未设置开机启动，跳过！"
	fi
	;;
stop)
	stop_wanup
	stop_gdddns
	;;
*)
	if [ "$gdddns_enable" == "1" ]; then
		start_wanup
		start_gdddns
   		http_response '服务已开启！页面将在3秒后刷新'
   	else
		stop_wanup
		stop_gdddns
		http_response '服务已关闭！页面将在3秒后刷新'
	fi
	;;
esac

