#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export zerotier_`

mkdir -p $KSROOT/init.d
cd /tmp
cp -rf /tmp/zerotier/scripts/* $KSROOT/scripts/
cp -rf /tmp/zerotier/init.d/* $KSROOT/init.d/
cp -rf /tmp/zerotier/webs/* $KSROOT/webs/
cp /tmp/zerotier/uninstall.sh $KSROOT/scripts/uninstall_zerotier.sh

chmod +x $KSROOT/scripts/zerotier_*
chmod +x $KSROOT/init.d/S99zerotier.sh

dbus set softcenter_module_zerotier_description=分布式的虚拟以太网
dbus set softcenter_module_zerotier_install=1
dbus set softcenter_module_zerotier_name=zerotier
dbus set softcenter_module_zerotier_title=ZeroTier
dbus set softcenter_module_zerotier_version=0.1

sleep 1
rm -rf /tmp/zerotier* >/dev/null 2>&1
