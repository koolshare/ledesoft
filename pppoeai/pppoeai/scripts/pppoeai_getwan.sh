#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
wanname=`uci show network|grep pppoe|cut -d "." -f2|sed ':a;N;$!ba;s#\n#>#g'`

if [ -n "$wanname" ];then
	dbus set pppoeai_wanname="$wanname"
fi

http_response "$wanname"




