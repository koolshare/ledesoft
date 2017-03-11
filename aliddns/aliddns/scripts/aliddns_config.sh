#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

if [ "`dbus get aliddns_enable`" = "1" ]; then
    dbus delay aliddns_timer `dbus get aliddns_interval` $KSROOT/scripts/aliddns_update.sh
    # run once after submit
	sleep 2
	sh $KSROOT/scripts/aliddns_update.sh
	sleep 1
	http_response '设置已保存！切勿重复提交！页面将在10秒后刷新'

else
    dbus remove __delay__aliddns_timer
    nvram set ddns_hostname_x=`nvram get ddns_hostname_old`
fi
