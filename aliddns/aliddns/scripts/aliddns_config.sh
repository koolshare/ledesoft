#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
if [ "`dbus get aliddns_enable`" = "1" ]; then
    cru d aliddns
    cru a aliddns "*/`dbus get aliddns_interval` * * * * /bin/sh $KSROOT/scripts/aliddns_update.sh"
    # run once after submit
	sh $KSROOT/scripts/aliddns_update.sh
	sleep 1
else
    cru d aliddns
    dbus set aliddns_last_act="<font color=red>服务未开启</font>"
fi
http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'
