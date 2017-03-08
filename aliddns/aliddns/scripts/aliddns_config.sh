#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
if [ "`dbus get aliddns_enable`" = "1" ]; then
    dbus delay aliddns_timer `dbus get aliddns_interval` $KSROOT/scripts/aliddns_update.sh
else
    dbus remove __delay__aliddns_timer
fi
