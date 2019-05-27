#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export koolproxy_`
mkdir -p /tmp/upload

# stop first
[ "$koolproxy_enable" == "1" ] && sh $KSROOT/koolproxy/kp_config.sh stop

# remove old files
rm -rf $KSROOT/bin/koolproxy >/dev/null 2>&1
rm -rf $KSROOT/res/icon-koolproxy.png >/dev/null 2>&1
rm -rf $KSROOT/scripts/Koolproxy_* >/dev/null 2>&1
rm -rf $KSROOT/webs/module_Koolproxy.asp >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/koolproxy >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/*.sh >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/gen_ca.sh >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/koolproxy_ipset.conf >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/openssl.cnf >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/version >/dev/null 2>&1
rm -rf $KSROOT/koolproxy/data/rules/* >/dev/null 2>&1

# copy new files
cd /tmp
mkdir -p $KSROOT/koolproxy
mkdir -p $KSROOT/init.d
mkdir -p $KSROOT/koolproxy/data
cp -rf /tmp/koolproxy/scripts/* $KSROOT/scripts/
cp -rf /tmp/koolproxy/webs/* $KSROOT/webs/
cp -rf /tmp/koolproxy/init.d/* $KSROOT/init.d/
if [ ! -f $KSROOT/koolproxy/data/rules/user.txt ];then
	cp -rf /tmp/koolproxy/* $KSROOT/
else
	mv $KSROOT/koolproxy/data/rules/user.txt /tmp/user.txt.tmp
	cp -rf /tmp/koolproxy/* $KSROOT/
	mv /tmp/user.txt.tmp $KSROOT/koolproxy/data/rules/user.txt
fi
cp -f /tmp/koolproxy/uninstall.sh $KSROOT/scripts/uninstall_koolproxy.sh
rm -rf $KSROOT/install.sh
rm -rf $KSROOT/uninstall.sh

[ ! -L "/tmp/upload/user.txt" ] && ln -sf $KSROOT/koolproxy/data/rules/user.txt /tmp/upload/user.txt

cd /
chmod 755 $KSROOT/koolproxy/*
chmod 755 $KSROOT/koolproxy/data/*
chmod 755 $KSROOT/scripts/*
chmod 755 $KSROOT/init.d/*
ln -sf  $KSROOT/koolproxy/koolproxy  $KSROOT/bin/koolproxy

# remove install tar
rm -rf /tmp/koolproxy* >/dev/null 2>&1

# remove old files if exist
find /etc/rc.d/ -name *koolproxy.sh* | xargs rm -rf
[ ! -L "/etc/rc.d/S93koolproxy.sh" ] && ln -sf $KSROOT/init.d/S93koolproxy.sh /etc/rc.d/S93koolproxy.sh

[ -z "$koolproxy_mode" ] && dbus set koolproxy_mode="1"
[ -z "$koolproxy_acl_default" ] && dbus set koolproxy_acl_default="1"
[ -z "$koolproxy_acl_list" ] && dbus set koolproxy_acl_list=" "
[ -z "$koolproxy_arp" ] && dbus set koolproxy_arp=" "

# add icon into softerware center
dbus set softcenter_module_koolproxy_description=koolproxy
dbus set softcenter_module_koolproxy_install=1
dbus set softcenter_module_koolproxy_home_url="Module_koolproxy.asp"
dbus set softcenter_module_koolproxy_name=koolproxy
dbus set softcenter_module_koolproxy_version=3.8.5
dbus set koolproxy_version=3.8.5

[ "$koolproxy_enable" == "1" ] && sh $KSROOT/koolproxy/kp_config.sh restart

exit 0

