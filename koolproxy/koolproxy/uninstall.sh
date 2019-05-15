#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

sh $KSROOT/koolproxy/kp_config.sh stop
rm -rf $KSROOT/bin/koolproxy >/dev/null 2>&1
rm -rf $KSROOT/res/icon-koolproxy.png >/dev/null 2>&1
rm -rf $KSROOT/scripts/KoolProxy_* >/dev/null 2>&1
rm -rf $KSROOT/scripts/Koolproxy_* >/dev/null 2>&1
rm -rf $KSROOT/webs/module_Koolproxy.asp >/dev/null 2>&1
rm -rf $KSROOT/koolproxy >/dev/null 2>&1
rm -rf $KSROOT/init.d/S93koolproxy.sh >/dev/null 2>&1
rm -rf /etc/rc.d/S93koolproxy.sh >/dev/null 2>&1
