#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

#From dbus to local variable
eval `dbus export softcenter_installing_`

#softcenter_installing_module 	#正在安装的模块
#softcenter_installing_todo 	#希望安装的模块
#softcenter_installing_tick 	#上次安装开始的时间
#softcenter_installing_version 	#正在安装的版本
#softcenter_installing_md5 	#正在安装的版本的md5值
#softcenter_installing_tar_url 	#模块对应的下载地址

#softcenter_installing_status=		#尚未安装
#softcenter_installing_status=0		#尚未安装
#softcenter_installing_status=1		#已安装
#softcenter_installing_status=2		#将被安装到jffs分区...
#softcenter_installing_status=3		#正在下载中...请耐心等待...
#softcenter_installing_status=4		#正在安装中...
#softcenter_installing_status=5		#安装成功！请5秒后刷新本页面！...
#softcenter_installing_status=6		#卸载中......
#softcenter_installing_status=7		#卸载成功！
#softcenter_installing_status=8		#没有检测到在线版本号！
#softcenter_installing_status=9		#正在下载更新......
#softcenter_installing_status=10	#正在安装更新...
#softcenter_installing_status=11	#安装更新成功，5秒后刷新本页！
#softcenter_installing_status=12	#下载文件校验不一致！
#softcenter_installing_status=13	#然而并没有更新！
#softcenter_installing_status=14	#正在检查是否有更新~
#softcenter_installing_status=15	#检测更新错误！

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
	logger $1
	http_response $1
}

uninstall_module() {
	if [ "$softcenter_installing_tick" = "" ]; then
		export softcenter_installing_tick=0
	fi
	LAST_TICK=`expr $softcenter_installing_tick + 20`
	if [ "$LAST_TICK" -ge "$CURR_TICK" -a "$softcenter_installing_module" != "" ]; then
		LOGGER "2" #"module $softcenter_installing_module is installing"
		exit 2
	fi

	if [ "$softcenter_installing_todo" = "" -o "$softcenter_installing_todo" = "softcenter" ]; then
		#curr module name not found
		LOGGER "3" #"module name not found"
		exit 3
	fi

	ENABLED=`dbus get "$softcenter_installing_todo""_enable"`
	if [ "$ENABLED" = "1" ]; then
		LOGGER "9" #"please disable this module than try again"
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
