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
	logger $1
	http_response $1
}

install_module() {
	if [ "$softcenter_home_url" = "" -o "$softcenter_installing_md5" = "" -o "$softcenter_installing_version" = "" ]; then
		LOGGER "<font color=red>错误：获取插件信息不完整</font>"
		exit 1
	fi

	if [ "$softcenter_installing_tick" = "" ]; then
		export softcenter_installing_tick=0
	fi
	LAST_TICK=`expr $softcenter_installing_tick + 20`
	if [ "$LAST_TICK" -ge "$CURR_TICK" -a "$softcenter_installing_module" != "" ]; then
		LOGGER "<font color=red>插件 $softcenter_installing_module 正在安装中，请稍后再试</font>"
		exit 2
	fi

	if [ "$softcenter_installing_todo" = "" ]; then
		#curr module name not found
		LOGGER "<font color=red>错误：未知的插件</font>"
		exit 3
	fi

	# Just ignore the old installing_module
	export softcenter_installing_module=$softcenter_installing_todo
	export softcenter_installing_tick=`date +%s`
	export softcenter_installing_status="2"
	dbus save softcenter_installing_
	sleep 2
	URL_SPLIT="/"
	#OLD_MD5=`dbus get softcenter_module_$softcenter_installing_module$MD5_SUFFIX`
	OLD_VERSION=`dbus get softcenter_module_$softcenter_installing_module$VER_SUFFIX`
	HOME_URL=`dbus get softcenter_home_url`
	TAR_URL=$HOME_URL$URL_SPLIT$softcenter_installing_tar_url
	FNAME=`basename $softcenter_installing_tar_url`

	if [ "$OLD_VERSION" = "" ]; then
		OLD_VERSION=0
	fi

	CMP=`versioncmp $softcenter_installing_version $OLD_VERSION`
	if [ -f $KSROOT/webs/Module_$softcenter_installing_module.sh -o "$softcenter_installing_todo" = "softcenter" ]; then
		CMP="-1"
	fi
	if [ "$CMP" = "-1" ]; then

	cd /tmp
	rm -f $FNAME
	rm -rf "/tmp/$softcenter_installing_module"
	dbus set softcenter_installing_status="3"
	sleep 2
	wget --no-check-certificate --tries=1 --timeout=15 $TAR_URL
	RETURN_CODE=$?

	if [ "$RETURN_CODE" != "0" ]; then
	dbus set softcenter_installing_status="12"
	sleep 2

	dbus set softcenter_installing_status="0"
	dbus set softcenter_installing_module=""
	dbus set softcenter_installing_todo=""
	LOGGER "<font color=red>下载失败：错误代码 $RETURN_CODE</font>"
	exit 4
	fi

	md5sum_gz=$(md5sum /tmp/$FNAME | sed 's/ /\n/g'| sed -n 1p)
	if [ "$md5sum_gz"x != "$softcenter_installing_md5"x ]; then
		LOGGER "<font color=red>错误MD5校验失败！软件中心插件MD5：$md5sum_gz</font>"
		dbus set softcenter_installing_status="12"
		rm -f $FNAME
		sleep 2

		dbus set softcenter_installing_status="0"
		dbus set softcenter_installing_module=""
		dbus set softcenter_installing_todo=""

		rm -f $FNAME
		rm -rf "/tmp/$softcenter_installing_module"
		exit
	else
		tar -zxf $FNAME
		dbus set softcenter_installing_status="4"
		sleep 2
		if [ ! -f /tmp/$softcenter_installing_module/install.sh ]; then
			dbus set softcenter_installing_status="0"
			dbus set softcenter_installing_module=""
			dbus set softcenter_installing_todo=""

			#rm -f $FNAME
			#rm -rf "/tmp/$softcenter_installing_module"

			LOGGER "<font color=red>错误：插件包中没有 Install.sh 文件。</font>"
			exit 5
		fi

		if [ -f /tmp/$softcenter_installing_module/uninstall.sh ]; then
			chmod 755 /tmp/$softcenter_installing_module/uninstall.sh
			mv /tmp/$softcenter_installing_module/uninstall.sh $KSROOT/scripts/uninstall_$softcenter_installing_todo.sh
		fi

		chmod a+x /tmp/$softcenter_installing_module/install.sh
		sh /tmp/$softcenter_installing_module/install.sh $1
		sleep 2

		rm -f $FNAME
		rm -rf "/tmp/$softcenter_installing_module"

		if [ "$softcenter_installing_module" != "softcenter" ]; then
			dbus set softcenter_installing_status="5"
			sleep 1
			dbus set "softcenter_module_$softcenter_installing_module$NAME_SUFFIX=$softcenter_installing_module"
			dbus set "softcenter_module_$softcenter_installing_module$MD5_SUFFIX=$softcenter_installing_md5"
			dbus set "softcenter_module_$softcenter_installing_module$VER_SUFFIX=$softcenter_installing_version"
			dbus set "softcenter_module_$softcenter_installing_module$INSTALL_SUFFIX=1"
			dbus set "$softcenter_installing_module$VER_SUFFIX=$softcenter_installing_version"
		else
			dbus set softcenter_version=$softcenter_installing_version;
			dbus set softcenter_md5=$softcenter_installing_md5
		fi
		dbus set softcenter_installing_module=""
		dbus set softcenter_installing_todo=""
		dbus set softcenter_installing_status="0"
		#LOGGER "ok"
	fi

	else
		LOGGER "已经是最新版本"
		dbus set softcenter_installing_status="13"
		sleep 3

		dbus set softcenter_installing_status="0"
		dbus set softcenter_installing_module=""
		dbus set softcenter_installing_todo=""
	fi
}

#LOGGER $BIN_NAME
case $BIN_NAME in
update)
	install_module
	;;
install)
	install_module
	;;
ks_app_install)
	install_module
	;;
stop)
	# reset installing status incase of install failed
	dbus set softcenter_installing_status="0"
	echo software center: do nothing
	;;
*)
	install_module
	;;
esac
