#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

# stop first
dbus set koolproxy_enable=0
[ -f $KSROOT/koolproxy/kp_config.sh ] && sh $KSROOT/koolproxy/kp_config.sh stop

# remove old files
rm -rf $KSROOT/bin/koolproxy >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/kp_config.sh >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/kp_rule_update.sh.sh >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/*.dat >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/*_*.txt >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/*.conf >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/gen_ca.sh >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/openssl.cnf >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/serial >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/version >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/rule_store >/dev/null 2>&1


# copy new files
cd /tmp
mkdir -p $KSROOT/koolproxy
mkdir -p $KSROOT/koolproxy/data
cp -rf /tmp/koolproxy/bin/* $KSROOT/bin/
cp -rf /tmp/koolproxy/scripts/* $KSROOT/scripts/
cp -rf /tmp/koolproxy/webs/* $KSROOT/webs/
cp -rf /tmp/koolproxy/res/* $KSROOT/res/
cp -rf /tmp/koolproxy/koolproxy/kp_config.sh $KSROOT/koolproxy/
cp -rf /tmp/koolproxy/koolproxy/rule_store $KSROOT/koolproxy/
cp -rf /tmp/koolproxy/koolproxy/data/koolproxy_ipset.conf $KSROOT/koolproxy/data/
cp -rf /tmp/koolproxy/koolproxy/data/gen_ca.sh $KSROOT/koolproxy/data/
cp -rf /tmp/koolproxy/koolproxy/data/openssl.cnf $KSROOT/koolproxy/data/
cp -rf /tmp/koolproxy/koolproxy/data/version $KSROOT/koolproxy/data/
if [ ! -f $KSROOT/koolproxy/data/user.txt ];then
	cp -rf /tmp/koolproxy/* $KSROOT/
else
	mv $KSROOT/koolproxy/data/user.txt /tmp/user.txt.tmp
	cp -rf /tmp/koolproxy/* $KSROOT/
	mv /tmp/user.txt.tmp $KSROOT/koolproxy/data/user.txt
fi

[ ! -d $KSROOT/koolproxy/data/certs ] && cp -rf /tmp/koolproxy/koolproxy/data/certs $KSROOT/koolproxy/data/
[ ! -d $KSROOT/koolproxy/data/private ] && cp -rf /tmp/koolproxy/koolproxy/data/private $KSROOT/koolproxy/data/
[ ! -L "/tmp/upload/user.txt" ] && ln -sf $KSROOT/koolproxy/data/user.txt /tmp/upload/user.txt
cp -f /tmp/koolproxy/uninstall.sh $KSROOT/scripts/uninstall_koolproxy.sh

cd /

chmod 755 $KSROOT/bin/koolproxy
chmod 755 $KSROOT/koolproxy/*
chmod 755 $KSROOT/koolproxy/data/*
chmod 755 $KSROOT/scripts/*

rm -rf /tmp/koolproxy* >/dev/null 2>&1

[ -z "$koolproxy_mode" ] && dbus set koolproxy_mode="1"
[ -z "$koolproxy_acl_default" ] && dbus set koolproxy_acl_default="1"
if [ -z "$koolproxy_rule_list" ];then
	dbus set koolproxy_rule_list="1<0<http://koolshare.b0.upaiyun.com/rules/1.dat<>1<1<http://koolshare.b0.upaiyun.com/rules/koolproxy.txt<>"
else
	ENTWARE=`echo "$koolproxy_rule_list" | grep "entware"`
	[ -n "$ENTWARE" ] && dbus set koolproxy_rule_list="1<0<http://koolshare.b0.upaiyun.com/rules/1.dat<>1<1<http://koolshare.b0.upaiyun.com/rules/koolproxy.txt<>"
fi


# add icon into softerware center
dbus set softcenter_module_koolproxy_description=koolproxy
dbus set softcenter_module_koolproxy_install=1
dbus set softcenter_module_koolproxy_home_url="Module_koolproxy.asp"
dbus set softcenter_module_koolproxy_name=koolproxy
dbus set softcenter_module_koolproxy_version=3.3.4
dbus set koolproxy_version=3.3.4

