#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

sh $KSROOT/koolproxy/koolproxy.sh stop
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
