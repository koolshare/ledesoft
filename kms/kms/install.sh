#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export kms`

# stop kms first
if [ "$kms_enable" == "1" ];then
	sh $KSROOT/scripts/kms_config.sh stop
fi

# cp files
cp -rf /tmp/kms/scripts/* $KSROOT/scripts/
cp -rf /tmp/kms/bin/* $KSROOT/bin/
cp -rf /tmp/kms/webs/* $KSROOT/webs/
cp -rf /tmp/kms/init.d/* $KSROOT/init.d/
chmod +x $KSROOT/scripts/kms*
chmod +x $KSROOT/bin/vlmcsd

# delete install tar
rm -rf /tmp/kms* >/dev/null 2>&1

# add icon into softerware center
dbus set softcenter_module_kms_install=1
dbus set softcenter_module_kms_version=1.3
dbus set softcenter_module_kms_name=kms
dbus set softcenter_module_kms_title=kms
dbus set softcenter_module_kms_description="巨硬套餐激活工具"

# remove old files if exist
find /etc/rc.d/ -name *kms.sh* | xargs rm -rf
rm -rf $KSROOT/scripts/kms.sh
rm -rf $KSROOT/scripts/firewall-start

# re-enable kms
sh $KSROOT/scripts/kms_config.sh start