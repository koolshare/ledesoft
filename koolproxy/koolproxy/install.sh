#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export koolproxy_`

# stop first
[ "$koolproxy_enable" == "1" ] && sh $KSROOT/koolproxy/kp_config.sh stop

#now remove acl data when version below 3.6.17, because the format has changed
COMP=`versioncmp $koolproxy_version 3.6.1.19`
if [ "$COMP" == "1" ];then
	dbus set koolproxy_acl_list=" "
fi
[ -z "$koolproxy_acl_list" ] && dbus set koolproxy_acl_list=" "

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
mkdir -p $KSROOT/init.d
mkdir -p $KSROOT/koolproxy/data
cp -rf /tmp/koolproxy/scripts/* $KSROOT/scripts/
cp -rf /tmp/koolproxy/webs/* $KSROOT/webs/
cp -rf /tmp/koolproxy/init.d/* $KSROOT/init.d/
if [ ! -f $KSROOT/koolproxy/data/user.txt ];then
	cp -rf /tmp/koolproxy/* $KSROOT/
else
	mv $KSROOT/koolproxy/data/user.txt /tmp/user.txt.tmp
	cp -rf /tmp/koolproxy/* $KSROOT/
	mv /tmp/user.txt.tmp $KSROOT/koolproxy/data/user.txt
fi

rm -rf $KSROOT/install.sh

[ ! -L "/tmp/upload/user.txt" ] && ln -sf $KSROOT/koolproxy/data/user.txt /tmp/upload/user.txt
cp -f /tmp/koolproxy/uninstall.sh $KSROOT/scripts/uninstall_koolproxy.sh

cd /
chmod 755 $KSROOT/koolproxy/koolproxy
chmod 755 $KSROOT/koolproxy/*
chmod 755 $KSROOT/koolproxy/data/*
chmod 755 $KSROOT/scripts/*
chmod 755 $KSROOT/init.d/*
ln -sf  $KSROOT/koolproxy/koolproxy  $KSROOT/bin/koolproxy


rm -rf /tmp/koolproxy* >/dev/null 2>&1

# remove old files if exist
find /etc/rc.d/ -name *koolproxy.sh* | xargs rm -rf

[ -z "$koolproxy_mode" ] && dbus set koolproxy_mode="1"
[ -z "$koolproxy_acl_default" ] && dbus set koolproxy_acl_default="1"


# add icon into softerware center
dbus set softcenter_module_koolproxy_description=koolproxy
dbus set softcenter_module_koolproxy_install=1
dbus set softcenter_module_koolproxy_home_url="Module_koolproxy.asp"
dbus set softcenter_module_koolproxy_name=koolproxy
dbus set softcenter_module_koolproxy_version=3.3.4
dbus set koolproxy_version=3.3.4


[ "$koolproxy_enable" == "1" ] && sh $KSROOT/koolproxy/kp_config.sh restart
