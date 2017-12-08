#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export sgame_`

PID=$(cat $pidfile 2>/dev/null)
loger() {
	echo "【$(date +%Y年%m月%d日\ %X)】: 停止ShadowVPN[$PID] $1"
}

loger ""

loger "为$intf删除NAT规则"
iptables -t nat -D POSTROUTING -o $intf -m comment --comment "softcenter: sgame" -j MASQUERADE >/dev/null 2>&1
iptables -D FORWARD -i $intf -m conntrack --ctstate RELATED,ESTABLISHED -m comment --comment "softcenter: sgame" -j ACCEPT >/dev/null 2>&1
iptables -D FORWARD -o $intf -m comment --comment "softcenter: sgame" -j ACCEPT >/dev/null 2>&1

if [ "$sgame_udp_enable" == "1" ];then
	server="$sgame_udp_server"
fi

ip route del $server
if [ "$sgame_basic_modeold" != 3 ]; then
	ip route del 0/1
	ip route del 128/1
	loger "将默认路由从VPN通道变更到默认"
fi
if [ -f /tmp/shadowvpn_routes ]; then
	sed -e "s/^/route del /" /tmp/shadowvpn_routes | ip -batch -
	loger "加入的路由表删除完成"
	rm -rf /tmp/shadowvpn_routes
fi

loger "ShadowVPN停止脚本 $0 运行完成！"
loger "------------------------- SGame 成功关闭 -------------------------"