#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export udpspeeder_`

dbus set udpspeeder_version=$version


start_udpspeeder(){
	[ -n "$udpspeeder_duplicate_time" ] && t="-t $udpspeeder_duplicate_time" || t=""
	[ -n "$udpspeeder_jitter" ] && j="-j $udpspeeder_jitter" || j=""
	[ -n "$udpspeeder_report" ] && r="--report $udpspeeder_report" || r=""
	[ -n "$udpspeeder_drop" ] && d="--random-drop $udpspeeder_drop" || d=""
	[ "$udpspeeder_disable_filter" == "1" ] && f="--disable-filter" || f=""
	UDPspeeder -l $udpspeeder_local_server:$udpspeeder_local_port -r $udpspeeder_remote_server:$udpspeeder_remote_port $udpspeeder_mode $t $j $r $d $f -d $udpspeeder_duplicate_nu -k "$udpspeeder_password" >/dev/null 2>&1 &
	sleep 1
	if [ -n "$udpspeeder_shell" ];then
		if [ -f "$udpspeeder_shell" ];then
			chmod +x $udpspeeder_shell
			start-stop-daemon -S -q -b -x $udpspeeder_shell
		fi
	fi
}

# used by rc.d
case $1 in
start)
	if [ "$udpspeeder_enable" == "1" ];then
		start_udpspeeder
	else
        killall UDPspeeder
	fi
	;;
stop)
	killall UDPspeeder
	;;
esac

# used by httpdb
case $2 in
start)
	if [ "$udpspeeder_enable" == "1" ];then
		killall UDPspeeder
		start_udpspeeder
		http_response '设置已保存！切勿重复提交！页面将在1秒后刷新'
	else
		killall UDPspeeder
        http_response '设置已保存！切勿重复提交！页面将在1秒后刷新'
    fi
	;;
stop)
	killall UDPspeeder
    http_response '设置已保存！切勿重复提交！页面将在1秒后刷新'
	;;
esac
