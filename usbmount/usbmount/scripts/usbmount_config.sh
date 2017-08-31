#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export usbmount_`

creat_start_up(){
if [ ! -L "/etc/hotplug.d/block/20-usbmount" ]; then
	ln -s /koolshare/scripts/usbmount_hotplug.sh /etc/hotplug.d/block/20-usbmount
fi
}

del_start_up(){
	rm -rf /etc/hotplug.d/block/20-usbmount >/dev/null 2>&1
}


if [ "$usbmount_enable" == "1" ]; then
	del_start_up
	creat_start_up
  	http_response '服务已开启！页面将在3秒后刷新'
else
	del_start_up
	echo_date "服务未开启，请先开启助手。"
	http_response '服务已关闭！页面将在3秒后刷新'
fi

