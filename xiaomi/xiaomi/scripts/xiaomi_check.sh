#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

eval `dbus export xiaomi_`
temperature=`cat /proc/dmu/temperature | cut -f 3 -d" " | cut -c 1,2 | grep "^[0-9]\{2\}"`

auto_start() {
	if [ $temperature -lt 80 ]; then
		NEWSPEED=2
	elif [ $temperature -ge 80 -a $temperature -lt 90 ];then
		NEWSPEED=3
	elif [ $temperature -ge 90 -a $temperature -lt 100 ];then
		NEWSPEED=4
	else
		NEWSPEED=2
	fi
	OLDSPEED=`nvram get fanctrl_dutycycle`
	if [ $OLDSPEED -ne $NEWSPEED ]; then
		nvram set fanctrl_dutycycle=$NEWSPEED
		nvram commit
	fi 
}

xiaomi_sleep() {
	if [ "$xiaomi_sleep" == "1" ]; then
		cru d xiaomi_start
		cru a xiaomixiaomi_start "0 $xiaomi_sleep_start_time * * * nvram set fanctrl_dutycycle=1"
		cru d xiaomi_end
		cru a xiaomi_end "0 $xiaomi_sleep_end_time * * * nvram set fanctrl_dutycycle=4"
	else
		cru d xiaomi_start
		cru d xiaomi_end
	fi
}

if [ "$xiaomi_custom_enable" == "1" ]; then
	case $xiaomi_last_speed in
	"1")
    		nvram set fanctrl_dutycycle=1
    	;;
	"2")
    		nvram set fanctrl_dutycycle=2
    	;;
	"3")
    		nvram set fanctrl_dutycycle=3
   	 ;;
	"4")
    		nvram set fanctrl_dutycycle=4
    	;;
	"5")
			nvram set fanctrl_dutycycle=5
		;;
	esac
	xiaomi_sleep
else
	auto_start
	xiaomi_sleep
fi

speed=`nvram get fanctrl_dutycycle`
dbus set xiaomi_last_cpu="<font color=red>$temperature°C</font>"
dbus set xiaomi_last_speed="<font color=green>$speed</font>"