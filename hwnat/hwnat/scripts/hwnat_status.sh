#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

fwlocal=`cat /etc/openwrt_release|grep DISTRIB_RELEASE|cut -d "'" -f 2|cut -d "V" -f 2`
date=`echo_date1`
checkversion=`versioncmp $fwlocal 2.17`

[ "$checkversion" == "1" ] && {
	http_response "<font color='#ff5500'>当前固件版本不支持开启硬件加速，最低支持版本为2.17！</font>"
	exit 0
}

check_config(){
  local flow flowhw
  flow=`uci get firewall.@defaults[0].flow_offloading`
  flowhw=`uci get firewall.@defaults[0].flow_offloading_hw`
  if [ "$flow" == "1" -a "$flowhw" == "1" ]; then
    local isrun errstatus
    isrun=`iptables -L FORWARD | grep FLOWOFFLOAD`
    [ -z "$isrun" ] && errstatus="<font color='#FF0000'>但设置未生效！"
    status1="【$date】 NAT硬件加速已开启！$errstatus"
  else
    status1="<font color='#FF0000'>NAT硬件加速未开启!"
  fi
}

check_config

http_response "$status1"
