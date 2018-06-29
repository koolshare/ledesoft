#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export xldoc_`

start_xldoc(){
	echo "127.0.0.1 hub5btmain.sandai.net" >> /etc/hosts
	echo "127.0.0.1 hub5emu.sandai.net" >> /etc/hosts
	echo "127.0.0.1 upgrade.xl9.xunlei.com" >> /etc/hosts
}

stop_xldoc(){
	sed -i '/sandai.net/d' /etc/hosts >/dev/null 2>&1
	sed -i '/xunlei.com/d' /etc/hosts >/dev/null 2>&1
	/etc/init.d/dnsmasq restart
}

if [ "$xldoc_enable" == "1" ]; then
	stop_xldoc
	start_xldoc
	/etc/init.d/dnsmasq restart
   	http_response '服务已开启！页面将在3秒后刷新'
else
	stop_xldoc
	http_response '服务已关闭！页面将在3秒后刷新'
fi
