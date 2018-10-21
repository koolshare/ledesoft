#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export iscsi_`

mkdir -p $KSROOT/init.d
cd /tmp
cp -rf /tmp/iscsi/bin/* $KSROOT/bin/
cp -rf /tmp/iscsi/scripts/* $KSROOT/scripts/
cp -rf /tmp/iscsi/init.d/* $KSROOT/init.d/
cp -rf /tmp/iscsi/webs/* $KSROOT/webs/
cp /tmp/iscsi/uninstall.sh $KSROOT/scripts/uninstall_iscsi.sh

chmod +x $KSROOT/bin/tgt*
chmod +x $KSROOT/scripts/iscsi_*
chmod +x $KSROOT/init.d/S99iscsi.sh

dbus set softcenter_module_iscsi_description=稳定高效的共享磁盘
dbus set softcenter_module_iscsi_install=1
dbus set softcenter_module_iscsi_name=iscsi
dbus set softcenter_module_iscsi_title=iSCSI服务器
dbus set softcenter_module_iscsi_version=0.1

sleep 1
rm -rf /tmp/iscsi* >/dev/null 2>&1
