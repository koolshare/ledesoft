#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

case $ACTION in
start)
	if ! pidof perpd > /dev/null; then
	   perpboot -d
	fi
	;;
stop)
	if pidof perpd > /dev/null; then
	   kill -9 `pidof perpboot`
	   kill -9 `pidof tinylog`
	   kill -9 `pidof perpd`
	fi
	;;
*)
	echo "Usage: $0 (start)"
	exit 1
	;;
esac
