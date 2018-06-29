#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export nat1_`

cp -rf /tmp/nat1/scripts/* $KSROOT/scripts/
cp -rf /tmp/nat1/webs/* $KSROOT/webs/
cp /tmp/nat1/uninstall.sh $KSROOT/scripts/uninstall_nat1.sh

chmod +x $KSROOT/scripts/nat1_*

dbus set softcenter_module_nat1_description="NAT类型-Full cone"
dbus set softcenter_module_nat1_install=1
dbus set softcenter_module_nat1_name=nat1
dbus set softcenter_module_nat1_title="Full cone NAT"
dbus set softcenter_module_nat1_version=0.1

sleep 1
rm -rf /tmp/nat1* >/dev/null 2>&1
