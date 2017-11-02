#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export acme_`

mkdir -p $KSROOT/init.d
mkdir -p $KSROOT/acme
cp -rf /tmp/acme/acme/* $KSROOT/acme/
cp -rf /tmp/acme/scripts/* $KSROOT/scripts/
cp -rf /tmp/acme/webs/* $KSROOT/webs/
cp /tmp/acme/uninstall.sh $KSROOT/scripts/uninstall_acme.sh

chmod +x $KSROOT/scripts/acme_*
chmod +x $KSROOT/acme/acme.sh
chmod +x $KSROOT/acme/dnsapi/*

dbus set softcenter_module_acme_description=自动部署SSL证书
dbus set softcenter_module_acme_install=1
dbus set softcenter_module_acme_name=acme
dbus set softcenter_module_acme_title="Let's Encrypt"
dbus set softcenter_module_acme_version=0.1

sleep 1
rm -rf /tmp/acme >/dev/null 2>&1
