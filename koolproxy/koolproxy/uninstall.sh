#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

sh $KSROOT/koolproxy/kp_config.sh stop
rm -rf $KSROOT/bin/koolproxy >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/koolproxy >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/kp_config.sh >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/kp_rule_update.sh >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/*.dat >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/*.txt >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/*.conf >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/gen_ca.sh >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/openssl.cnf >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/serial >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/version >/dev/null 2>&1
rm -rf $KSROOT/init.d/S93koolproxy.sh >/dev/null 2>&1
rm -rf /etc/rc.d/S93koolproxy.sh >/dev/null 2>&1
rm -rf $KSROOT/scripts/KoolProxy_* >/dev/null 2>&1
