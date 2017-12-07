#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export sgame_`

PID=$(cat $pidfile 2>/dev/null)
loger() {
	echo "【$(date +%Y年%m月%d日\ %X)】: 启动ShadowVPN[$PID] $1"
}

loger ""

ip addr add $net dev $intf
ip link set $intf mtu $mtu
ip link set $intf up
loger "VPN接口配置完成"

loger "为$intf设置NAT规则"
iptables -t nat -A POSTROUTING -o $intf -m comment --comment "softcenter: sgame" -j MASQUERADE >/dev/null 2>&1
iptables -I FORWARD 1 -i $intf -m conntrack --ctstate RELATED,ESTABLISHED -m comment --comment "softcenter: sgame" -j ACCEPT >/dev/null 2>&1
iptables -I FORWARD 1 -o $intf -m comment --comment "softcenter: sgame" -j ACCEPT >/dev/null 2>&1

if [ "$sgame_udp_enable" == "1" ];then
	server="$sgame_udp_server"
fi
foreigngateway=`ubus call network.interface."$sgame_wan_foreign" status | grep nexthop | grep -oE '([0-9]{1,3}.){3}.[0-9]{1,3}'`
[ -z "$foreigngateway" ] && foreigngateway=$(ip route show 0/0 | sed -e 's/.* via \([^ ]*\).*/\1/')
chinagateway=`ubus call network.interface."$sgame_wan_china" status | grep nexthop | grep -oE '([0-9]{1,3}.){3}.[0-9]{1,3}'`
[ -z "$chinagateway" ] && chinagateway=$(ip route show 0/0 | sed -e 's/.* via \([^ ]*\).*/\1/')

loger "国内出口：$sgame_wan_china  网关: $chinagateway"
loger "VPN出口：$sgame_wan_foreign  网关: $foreigngateway"
suf="dev $intf"
ip route add $server via $foreigngateway
if [ "$sgame_basic_mode" != 3 ]; then
	ip route add 0.0.0.0/1 dev $intf
	ip route add 128.0.0.0/1 dev $intf
	loger "将默认路由设置到 VPN 通道"
	suf="via $chinagateway"
fi

[ "$sgame_basic_mode" == "1" ] && {
	loger "全局模式已经载入"
}
[ "$sgame_basic_mode" == "2" ] && {
	grep -E "^([0-9]{1,3}\.){3}[0-9]{1,3}" $KSROOT/sgame/chnroute.txt >/tmp/shadowvpn_routes
	sed -e "s/^/route add /" -e "s/$/ $suf/" /tmp/shadowvpn_routes | ip -batch -
	loger "大陆白名单模式已经载入"
}
[ "$sgame_basic_mode" == "3" ] && {
	blackip=`echo "$sgame_wan_black_ip" | base64_decode | sort -u`
	if [ -n "$blackip" ]; then
		grep -E "^([0-9]{1,3}\.){3}[0-9]{1,3}" $blackip >/tmp/shadowvpn_routes
		sed -e "s/^/route add /" -e "s/$/ $suf/" /tmp/shadowvpn_routes | ip -batch -
		loger "黑名单模式已经载入"
	else
		loger "你选择使用黑名单模式，但黑名单为空！"
	fi
}
dbus set sgame_basic_modeold=$sgame_basic_mode

loger "SGame初始化脚本 $0 运行完成！"
loger "------------------------- SGame 启动完毕 -------------------------"