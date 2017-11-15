#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export ssrserver_`

mkdir -p $KSROOT/init.d
cd /tmp
cp -rf /tmp/ssrserver/scripts/* $KSROOT/scripts/
cp -rf /tmp/ssrserver/init.d/* $KSROOT/init.d/
cp -rf /tmp/ssrserver/webs/* $KSROOT/webs/
cp /tmp/ssrserver/uninstall.sh $KSROOT/scripts/uninstall_ssrserver.sh

chmod +x $KSROOT/scripts/ssrserver_*
chmod +x $KSROOT/init.d/S99ssrserver.sh

dbus set softcenter_module_ssrserver_description=科学上网服务器
dbus set softcenter_module_ssrserver_install=1
dbus set softcenter_module_ssrserver_name=ssrserver
dbus set softcenter_module_ssrserver_title="SSR Server"
dbus set softcenter_module_ssrserver_version=0.1

sleep 1
rm -rf /tmp/ssrserver >/dev/null 2>&1
