#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export sfe_`

have_cm() {
	[ -d "/sys/kernel/debug/ecm" ] && echo 1 && return

	echo 0
}

load_sfe_cm() {
	local kernel_version=$(uname -r)

	#shortcut-fe-drv.ko is not needed because other connection manager is not enabled
	[ -d "/sys/module/shortcut_fe_drv" ] && rmmod shortcut_fe_drv

	[ -e "/lib/modules/$kernel_version/shortcut-fe-cm.ko" ] && {
		[ -d /sys/module/shortcut_fe_cm ] || insmod /lib/modules/$kernel_version/shortcut-fe-cm.ko
	}
	[ -e "/lib/modules/$kernel_version/fast-classifier.ko" ] && {
		[ -d /sys/module/fast_classifier ] || insmod /lib/modules/$kernel_version/fast-classifier.ko
	}
}

start_sfe(){
	[ "$(have_cm)" = "1" ] || load_sfe_cm
}

other_set(){
	if [ "$sfe_ipv4" == "1" ]; then
		local sfe_ipv4=`cat /sys/sfe_ipv4/debug_dev`
		mknod /dev/sfe_ipv4 c $sfe_ipv4 0
	else
		rm -rf /dev/sfe_ipv4
	fi
	if [ "$sfe_ipv6" == "1" ]; then
		local sfe_ipv6=`cat /sys/sfe_ipv6/debug_dev`
		mknod /dev/sfe_ipv6 c $sfe_ipv6 0
	else
		rm -rf /dev/sfe_ipv6
	fi
	if [ "$sfe_bridge" == "1" ]; then
       echo 1 > /sys/fast_classifier/skip_to_bridge_ingress
      else
       echo 0 > /sys/fast_classifier/skip_to_bridge_ingress
	fi
}

stop_sfe(){
	[ -d /sys/module/shortcut_fe_cm ] && rmmod shortcut_fe_cm
	[ -d /sys/module/fast_classifier ] && rmmod fast_classifier
}

creat_start_up(){
	[ ! -L "/etc/rc.d/S72sfe.sh" ] && ln -sf /koolshare/init.d/S72sfe.sh /etc/rc.d/S72sfe.sh
}


if [ "$sfe_enable" == "1" ]; then
	stop_sfe
	sleep 1
	start_sfe
	other_set
	creat_start_up
   	http_response '服务已开启！页面将在3秒后刷新'
else
	stop_sfe
	http_response '服务已关闭！页面将在3秒后刷新'
fi

