#! /bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

mkdir -p $KSROOT/init.d
mkdir -p /tmp/upload

cd /tmp
cp -rf /tmp/aria2/aria2 /koolshare/
cp -rf /tmp/aria2/scripts/* /koolshare/scripts/
cp -rf /tmp/aria2/webs/* /koolshare/webs/
cp -rf /tmp/aria2/init.d/* /koolshare/init.d/
cp -rf /tmp/aria2/uninstall.sh $KSROOT/scripts/uninstall_aria2.sh


[ ! -f /koolshare/aria2/aria2.session ] && touch /koolshare/aria2/aria2.session
[ -f /koolshare/aria2/aria2.conf ] && rm -rf /koolshare/aria2/aria2.conf
[ -f /koolshare/aria2/aria2_run.sh ] && rm -rf /koolshare/aria2/aria2_run.sh
[ -f /koolshare/aria2/aria2_uninstall.sh ] && rm -rf /koolshare/aria2/aria2_uninstall.sh

chmod 755 /koolshare/aria2/*
chmod 755 /koolshare/init.d/S96aria2.sh
chmod 755 /koolshare/scripts/aria2*

dbus set softcenter_module_aria2_install=1
dbus set softcenter_module_aria2_version=0.1
dbus set softcenter_module_aria2_description="aria2下载工具"

sh $KSROOT/scripts/aria2_config.sh

rm -rf /tmp/aria2* >/dev/null 2>&1
