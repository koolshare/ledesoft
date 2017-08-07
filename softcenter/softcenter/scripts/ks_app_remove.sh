#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

#From dbus to local variable
eval `dbus export softcenter_installing_`

softcenter_home_url=`dbus get softcenter_home_url`
CURR_TICK=`date +%s`
BIN_NAME=$(basename "$0")
BIN_NAME="${BIN_NAME%.*}"
if [ "$ACTION" != "" ]; then
	BIN_NAME=$ACTION
fi

VER_SUFFIX=_version
MD5_SUFFIX=_md5
NAME_SUFFIX=_name
INSTALL_SUFFIX=_install
UNINSTALL_SUFFIX=_uninstall

LOGGER() {
#	echo $1
	http_response $1
	logger $1
	
}

uninstall_module() {
	if [ "$softcenter_installing_tick" = "" ]; then
		export softcenter_installing_tick=0
	fi
	LAST_TICK=`expr $softcenter_installing_tick + 20`
	if [ "$LAST_TICK" -ge "$CURR_TICK" -a "$softcenter_installing_module" != "" ]; then
		LOGGER "<font color=red>插件 $softcenter_installing_module 正在安装中</font>"
		exit 2
	fi

	if [ "$softcenter_installing_todo" = "" -o "$softcenter_installing_todo" = "softcenter" ]; then
		#curr module name not found
		LOGGER "<font color=red>不存在的插件</font>"
		exit 3
	fi

	ENABLED=`dbus get "$softcenter_installing_todo""_enable"`
	if [ "$ENABLED" = "1" ]; then
		LOGGER "<font color=red>程序正在运行，请关闭后再试！</font>"
		exit 4
	fi

	# Just ignore the old installing_module
	export softcenter_installing_module=$softcenter_installing_todo
	export softcenter_installing_tick=`date +%s`
	export softcenter_installing_status="6"
	dbus save softcenter_installing_

	dbus remove "softcenter_module_$softcenter_installing_module$MD5_SUFFIX"
	dbus remove "softcenter_module_$softcenter_installing_module$VER_SUFFIX"
	dbus remove "softcenter_module_$softcenter_installing_module$INSTALL_SUFFIX"
	dbus remove "softcenter_module_$softcenter_installing_module$NAME_SUFFIX"

	txt=`dbus list $softcenter_installing_todo`
	printf "%s\n" "$txt" |
	while IFS= read -r line; do
		line2="${line%=*}"
		if [ "$line2" != "" ]; then
			dbus remove $line2
		fi
	done

	sleep 3
	dbus set softcenter_installing_module=""
	dbus set softcenter_installing_status="7"
	sleep 1
	dbus set softcenter_installing_todo=""

	#try to call uninstall script
	if [ -f "$KSROOT/scripts/$softcenter_installing_todo$UNINSTALL_SUFFIX.sh"]; then
 		sh $KSROOT/scripts/$softcenter_installing_todo$UNINSTALL_SUFFIX.sh
	elif [ -f "$KSROOT/scripts/uninstall_$softcenter_installing_todo.sh" ]; then
		sh $KSROOT/scripts/uninstall_$softcenter_installing_todo.sh
	else
		rm -f $KSROOT/webs/Module_$softcenter_installing_todo.asp
        rm -f $KSROOT/init.d/S*$softcenter_installing_todo.sh
	fi
	curl -s $KSURL/"$softcenter_installing_module"/"$softcenter_installing_module"/install.sh >/dev/null 2>&1
	dbus set softcenter_installing_status="0"
}

#LOGGER $BIN_NAME
case $BIN_NAME in
start)
	sh $KSROOT/perp/perp.sh stop
	sh $KSROOT/perp/perp.sh start
	;;
ks_app_remove)
	uninstall_module
	;;
*)
	uninstall_module
	;;
esac
