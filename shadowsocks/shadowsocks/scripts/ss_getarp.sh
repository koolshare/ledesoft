#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
arp=`arp | grep br0 | grep -v incomplete | sed 's/ (/</g'|sed 's/) at /</'|cut -d " " -f1|sed ':a;N;$!ba;s#\n#>#g'`

if [ -n "$arp" ];then
	dbus set ss_basic_arp="$arp"
fi

http_response "$arp"




