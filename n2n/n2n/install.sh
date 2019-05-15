#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export n2n_`

mkdir -p $KSROOT/init.d
cd /tmp
cp -rf /tmp/n2n/bin/* $KSROOT/bin/
cp -rf /tmp/n2n/scripts/* $KSROOT/scripts/
cp -rf /tmp/n2n/init.d/* $KSROOT/init.d/
cp -rf /tmp/n2n/webs/* $KSROOT/webs/
cp /tmp/n2n/uninstall.sh $KSROOT/scripts/uninstall_n2n.sh

chmod +x $KSROOT/bin/edge
chmod +x $KSROOT/bin/supernode
chmod +x $KSROOT/scripts/n2n_*
chmod +x $KSROOT/init.d/S99n2n.sh

dbus set softcenter_module_n2n_description=开源的P2P加密组网
dbus set softcenter_module_n2n_install=1
dbus set softcenter_module_n2n_name=n2n
dbus set softcenter_module_n2n_title="N2N V2"
dbus set softcenter_module_n2n_version=0.1

sleep 1
rm -rf /tmp/n2n* >/dev/null 2>&1
