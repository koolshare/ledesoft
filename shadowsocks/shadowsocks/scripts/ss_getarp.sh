#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
arp=`arp | grep br0 | grep -v incomplete | sed 's/ (/</g'|sed 's/) at /</'|cut -d " " -f1|sed ':a;N;$!ba;s#\n#>#g'`
dbus set ss_basic_arp="$arp"

http_response "$arp"




