#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export dnspod_`

start_wanup(){
    #script_wanup=`nvram get script_wanup`
    if [ -n "$script_wanup" ];then
        wanstart=`echo $script_wanup | grep -E "$KSROOT/scripts/dnspod_update.sh"`
        if [ -z "$wanstart" ];then
            nvram set script_wanup="$script_wanup
$KSROOT/scripts/dnspod_update.sh"
        fi
    else
        nvram set script_wanup="$KSROOT/scripts/dnspod_update.sh"
    fi
    nvram commit
    sh $KSROOT/scripts/dnspod_update.sh
	sleep 1
}

start_interval(){
    cru d dnspod
    cru a dnspod "*/$dnspod_interval * * * * /bin/sh $KSROOT/scripts/dnspod_update.sh"
    sh $KSROOT/scripts/dnspod_update.sh
	sleep 1
}

stop_wanup(){
    nvram set script_wanup="`nvram get script_wanup|sed 's/\/jffs\/koolshare\/scripts\/dnspod_update.sh//g'`"
    nvram commit
    dbus set dnspod_last_act="<font color=red>服务未开启</font>"
}

stop_interval(){
    cru d dnspod
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
        if [ ! -L "$KSROOT/init.d/S91Dnspod.sh" ]; then 
		    ln -sf $KSROOT/scripts/dnspod_config.sh $KSROOT/init.d/S91Dnspod.sh
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
        if [ ! -L "$KSROOT/init.d/S91Dnspod.sh" ]; then 
		    ln -sf $KSROOT/scripts/dnspod_config.sh $KSROOT/init.d/S91Dnspod.sh
	    fi
        logger "[软件中心]: 启动Dnspod！"
    else
    if [ -L "$KSROOT/init.d/S91Dnspod.sh" ]; then 
		rm -rf $KSROOT/init.d/S91Dnspod.sh
	fi
    stop_wanup
    stop_interval
    logger "[软件中心]: 关闭Dnspod！"
    fi
    http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'
	;;
esac
