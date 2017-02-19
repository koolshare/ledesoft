#!/bin/sh

if [ -z $KSROOT ]; then
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
fi

plugin.sh stop
plugin.sh start
dbus fire onwanstart
