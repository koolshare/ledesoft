#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export dnspod_`

start_wanup(){
    cat > /etc/hotplug.d/iface/98-dnspod <<-EOF
		#!/bin/sh
		case "$ACTION" in
		ifup)
		sh $KSROOT/scripts/dnspod_update.sh
		;;
		esac
EOF
}

start_interval(){
    sed -i '/dnspod_update.sh/d' /etc/crontabs/root >/dev/null 2>&1
    echo "*/$dnspod_interval * * * * /bin/sh $KSROOT/scripts/dnspod_update.sh" >> /etc/crontabs/root
    sh $KSROOT/scripts/dnspod_update.sh
	sleep 1
	if [ ! -L "/etc/rc.d/S98dnspod.sh" ]; then 
		ln -sf $KSROOT/init.d/S98dnspod.sh /etc/rc.d/S98dnspod.sh
	fi
}

stop_wanup(){
    rm -rf /etc/hotplug.d/iface/98-dnspod >/dev/null 2>&1
}

stop_interval(){
    sed -i '/dnspod_update.sh/d' /etc/crontabs/root >/dev/null 2>&1
    dbus set dnspod_last_act="<font color=red>服务未开启</font>"
}

case $ACTION in
start)
	if [ "$dnspod_enable" = "1" ]; then
        if [ "$dnspod_up" = "1" ];then
            stop_interval
            start_wanup
        else
            stop_wanup
            start_interval
        fi
        if [ ! -L "/etc/rc.d/S98dnspod.sh" ]; then 
		    ln -sf $KSROOT/init.d/S98dnspod.sh /etc/rc.d/S98dnspod.sh
	    fi
        logger "[软件中心]: 启动Dnspod！"
    else
        logger "[软件中心]: Dnspod未设置开机启动，跳过！"
	fi
	;;
stop)
	stop_wanup
    stop_interval
    logger "[软件中心]: 关闭Dnspod！"
	;;
*)
	if [ "$dnspod_enable" = "1" ]; then
        if [ "$dnspod_up" = "1" ];then
            stop_interval
            start_wanup
        else
            stop_wanup
            start_interval
        fi
        if [ ! -L "/etc/rc.d/S98dnspod.sh" ]; then 
		    ln -sf $KSROOT/init.d/S98dnspod.sh /etc/rc.d/S98dnspod.sh
	    fi
        logger "[软件中心]: 启动Dnspod！"
    else
    if [ -L "/etc/rc.d/S98dnspod.sh" ]; then 
		rm -rf /etc/rc.d/S98dnspod.sh
	fi
    stop_wanup
    stop_interval
    logger "[软件中心]: 关闭Dnspod！"
    fi
    http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'
	;;
esac
