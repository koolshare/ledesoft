#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export wireguard_`

mkdir -p $KSROOT/init.d
mkdir -p $KSROOT/wireguard
cp -rf /tmp/wireguard/init.d/* $KSROOT/init.d/
cp -rf /tmp/wireguard/wireguard/* $KSROOT/wireguard/
cp -rf /tmp/wireguard/scripts/* $KSROOT/scripts/
cp -rf /tmp/wireguard/webs/* $KSROOT/webs/
cp /tmp/wireguard/uninstall.sh $KSROOT/scripts/uninstall_wireguard.sh

chmod +x $KSROOT/scripts/wireguard_*
chmod +x $KSROOT/scripts/uninstall_wireguard.sh

dbus set softcenter_module_wireguard_description=高效的次世代VPN
dbus set softcenter_module_wireguard_install=1
dbus set softcenter_module_wireguard_name=wireguard
dbus set softcenter_module_wireguard_title="WireGuard"
dbus set softcenter_module_wireguard_version=0.1

sleep 1
rm -rf /tmp/wireguard >/dev/null 2>&1
