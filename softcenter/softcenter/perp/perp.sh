#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

kill_all_process(){
	killall perpboot
	killall tinylog
	killall perpd
	killall httpdb
	#killall skipd
}

case $ACTION in
start)
	kill_all_process >/dev/null 2>&1
	sleep 1
	chmod -t $PERP_BASE/httpdb
	#chmod +t $PERP_BASE/skipd
	perpboot -d
	;;
stop)
	kill_all_process >/dev/null 2>&1
	;;
*)
	echo "Usage: $0 (start)"
	exit 1
	;;
esac

