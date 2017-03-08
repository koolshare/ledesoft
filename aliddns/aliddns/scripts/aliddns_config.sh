#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
http_response '设置已保存，请2分钟后查看状态！切勿重复提交！页面将在10秒后刷新'
if [ "`dbus get aliddns_enable`" = "1" ]; then
    dbus delay aliddns_timer `dbus get aliddns_interval` $KSROOT/scripts/aliddns_update.sh

else
    dbus remove __delay__aliddns_timer

fi
