#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export ikev1_`

mkdir -p $KSROOT/init.d
cd /tmp
cp -rf /tmp/ikev1/scripts/* $KSROOT/scripts/
cp -rf /tmp/ikev1/init.d/* $KSROOT/init.d/
cp -rf /tmp/ikev1/webs/* $KSROOT/webs/
cp /tmp/ikev1/uninstall.sh $KSROOT/scripts/uninstall_ikev1.sh

chmod +x $KSROOT/scripts/ikev1_*
chmod +x $KSROOT/init.d/S99ikev1.sh

dbus set softcenter_module_ikev1_description=高安全的企业VPN服务器
dbus set softcenter_module_ikev1_install=1
dbus set softcenter_module_ikev1_name=ikev1
dbus set softcenter_module_ikev1_title=IPsec服务器
dbus set softcenter_module_ikev1_version=0.1

sleep 1
rm -rf /tmp/ikev1* >/dev/null 2>&1
