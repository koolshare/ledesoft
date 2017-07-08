#!/bin/sh
#2017/04/21 by kenney
#version 0.2

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

if [ "`dbus get xunlei_enable`" = "1" ]; then
	now=`date "+%Y-%m-%d %H:%M:%S"`
    cru d xunlei
    cru a xunlei "*/10 * * * * /bin/sh $KSROOT/scripts/xunlei_config.sh"
    # run once after submit
	stat=`ps|grep ETMDaemon|grep -v grep|wc -l`
	n=1
	while [ $stat == 0 ];do
		sh $KSROOT/scripts/xunlei_start.sh
		sleep 10
		stat=`ps|grep ETMDaemon|grep -v grep|wc -l`
		if [ $n == 3 ];then
			dbus set xunlei_last_act="<font color=red>$now 错误：服务无法正常启动</font>"
			exit 0
		fi
		let n++
	done
	sysinfo_port=`cat /tmp/xunlei.log|grep "YOUR CONTROL PORT IS:"|awk -F' ' '{print $5}'|sed -n 2p`
	getinfo=`curl -s http://127.0.0.1:${sysinfo_port}/getsysinfo|sed 's/ //g'|sed 's/"//g'`
	net_ok=`echo $getinfo|cut -d',' -f2`
	bind_ok=`echo $getinfo|cut -d',' -f4`
	ackey=`echo $getinfo|cut -d',' -f5`
	disk_ok=`echo $getinfo|cut -d',' -f6`
	version=`echo $getinfo|cut -d',' -f7`
	user_name=`echo $getinfo|cut -d',' -f8`

	if [ $bind_ok == 1 ];then
		ackey="<font color=green>已绑定</font>"
	else user_name="<font color=red>未绑定</font>"
	fi
	if [ $disk_ok == 1 ];then
		disk_ok="<font color=green>已挂载</font>"
	else disk_ok="<font color=red>未挂载</font>"
	fi

	dbus set xunlei_version="$version"
	dbus set xunlei_ackey="$ackey"
	dbus set xunlei_user="$user_name"
	dbus set xunlei_disk="$disk_ok"
	
	if [ $net_ok == 0 ];then
		dbus set xunlei_last_act="<font color=red>$now 网络异常</font>"
	else dbus set xunlei_last_act="<font color=green>$now 运行正常</font>"
	fi
	if [ ! -L "$KSROOT/init.d/S90Xunlei.sh" ]; then 
		    ln -sf $KSROOT/scripts/xunlei_config.sh $KSROOT/init.d/S90Xunlei.sh
	fi
else
    cru d xunlei
	$KSROOT/xunlei/portal -s &
	rm -rf $KSROOT/init.d/S90Xunlei.sh
    dbus set xunlei_last_act="<font color=red>服务未开启</font>"
fi
http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'