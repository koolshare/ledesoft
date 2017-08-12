#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
arp=`arp | grep br-lan | grep -v incomplete | sed 's/ (/</g'|sed 's/) at /</'|cut -d " " -f1|sed ':a;N;$!ba;s#\n#>#g'`

if [ -n "$arp" ];then
	dbus set koolproxy_arp="$arp"
fi

http_response "$arp"




