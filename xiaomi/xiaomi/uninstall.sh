#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export xiaomi_`

xiaomi_config.sh stop
rm -rf $KSROOT/res/icon-xiaomi*
rm -rf $KSROOT/webs/Module_xiaomi.asp
rm -rf $KSROOT/scripts/xiaomi_*
