#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
wanname=`uci show network|grep pppoe|cut -d "." -f2|sed ':a;N;$!ba;s#\n#>#g'`

if [ -n "$wanname" ];then
	urlname="url>"
else
	urlname="url"
fi
http_response "$urlname$wanname"
