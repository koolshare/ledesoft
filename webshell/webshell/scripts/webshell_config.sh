#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
pid=`ps|grep webshell|grep -v grep|grep -v sh|awk '{print $1}'`

if [ -z "$pid" ]; then
	logger start webshell
	webshell -d 1 -f /tmp/.webshell-lock
else
	logger webshell is already running
fi