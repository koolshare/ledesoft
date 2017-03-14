#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

sh $KSROOT/koolproxy/koolproxy.sh stop
rm -rf $KSROOT/bin/koolproxy >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/kp_config.sh >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/kp_rule_update.sh >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/*.dat
rm -rf $KSROOT/koolproxy/data/*.txt
rm -rf $KSROOT/koolproxy/data/*.conf
rm -rf $KSROOT/koolproxy/data/gen_ca.sh
rm -rf $KSROOT/koolproxy/data/openssl.cnf
rm -rf $KSROOT/koolproxy/data/serial
rm -rf $KSROOT/koolproxy/data/version
