#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export hwnat_`

start_hwnat(){
  uci set firewall.@defaults[0].flow_offloading=1
  uci set firewall.@defaults[0].flow_offloading_hw=1
  uci commit
  /etc/init.d/firewall restart
}

stop_hwnat(){
  uci set firewall.@defaults[0].flow_offloading=0
  uci set firewall.@defaults[0].flow_offloading_hw=0
  uci commit
  /etc/init.d/firewall restart
}

if [ "$hwnat_enable" == "1" ]; then
	start_hwnat
  http_response '服务已开启！页面将在3秒后刷新'
else
	stop_hwnat
	http_response '服务已关闭！页面将在3秒后刷新'
fi

