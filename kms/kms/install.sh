#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export kms`

mkdir -p $KSROOT/init.d
mkdir -p /tmp/upload

# stop kms first
if [ "$kms_enable" == "1" ];then
	sh $KSROOT/scripts/kms_config.sh stop
fi

sed -i '/kms_config.sh/d' /etc/firewall.user >/dev/null 2>&1

# cp files
cp -rf /tmp/kms/scripts/* $KSROOT/scripts/
cp -rf /tmp/kms/bin/* $KSROOT/bin/
cp -rf /tmp/kms/webs/* $KSROOT/webs/
cp -rf /tmp/kms/init.d/* $KSROOT/init.d/
chmod +x $KSROOT/scripts/kms*
chmod +x $KSROOT/bin/vlmcsd

# make some links
[ ! -L "/etc/rc.d/S97kms.sh" ] && ln -sf $KSROOT/init.d/S97kms.sh /etc/rc.d/S97kms.sh

# delete install tar
rm -rf /tmp/kms* >/dev/null 2>&1

# add icon into softerware center
dbus set softcenter_module_kms_install=1
dbus set softcenter_module_kms_version=1.3
dbus set softcenter_module_kms_name=kms
dbus set softcenter_module_kms_title=KMS
dbus set softcenter_module_kms_description="巨硬套餐激活工具"

# remove old files if exist
find /etc/rc.d/ -name *kms.sh* | xargs rm -rf
rm -rf $KSROOT/scripts/kms.sh
rm -rf $KSROOT/scripts/firewall-start

# re-enable kms
sh $KSROOT/scripts/kms_config.sh start