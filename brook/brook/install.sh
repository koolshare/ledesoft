#! /bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

mkdir -p $KSROOT/init.d
mkdir -p $KSROOT/brook
mkdir -p /tmp/upload

cd /tmp
cp -rf /tmp/brook/brook /koolshare/brook/
cp -rf /tmp/brook/scripts/* /koolshare/scripts/
cp -rf /tmp/brook/webs/* /koolshare/webs/
cp -rf /tmp/brook/init.d/* /koolshare/init.d/
cp -rf /tmp/brook/uninstall.sh $KSROOT/scripts/uninstall_brook.sh

chmod 755 /koolshare/bin/brook
chmod 755 /koolshare/bin/dnsforwarder
chmod 755 /koolshare/bin/redsocks2
chmod 755 /koolshare/init.d/S98brook.sh
chmod 755 /koolshare/scripts/brook*

dbus set softcenter_module_brook_description="全平台Socks5代理"
dbus set softcenter_module_brook_install=1
dbus set softcenter_module_brook_name=brook
dbus set softcenter_module_brook_title="Brook"
dbus set softcenter_module_brook_version=0.1

rm -rf /tmp/brook* >/dev/null 2>&1
