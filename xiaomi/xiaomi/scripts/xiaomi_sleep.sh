#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

eval `dbus export xiaomi_`

case $ACTION in
enable)
	if [ "$xiaomi_sleep" == "1" ]; then
		if [ ! "$xiaomi_custom_enable" == "1" ]; then
			dbus set xiaomi_custom_enable=1
			dbus set xiaomi_speed=1
		fi
		nvram set fanctrl_dutycycle=1
	fi
	;;
disable)
	if [ "$xiaomi_sleep" == "1" ]; then
		[ "$xiaomi_custom_enable" == "1" ] && dbus set xiaomi_custom_enable=0
		nvram set fanctrl_dutycycle=4
	fi
	;;
esac