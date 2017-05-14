#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

temperature=`cat /proc/dmu/temperature | cut -f 3 -d" " | cut -c 1,2 | grep "^[0-9]\{2\}"`
speed=`nvram get fanctrl_dutycycle`|| ""

http_response "$temperature@@$speed"