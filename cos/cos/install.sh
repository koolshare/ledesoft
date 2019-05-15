#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
fwlocal=`cat /etc/openwrt_release|grep DISTRIB_RELEASE|cut -d "'" -f 2|cut -d "V" -f 2`
checkversion=`versioncmp $fwlocal 2.30`
eval `dbus export cos_`

mkdir -p $KSROOT/init.d

if [ "$checkversion" == "1" ]; then
	cp -rf /tmp/cos/bin/cos1 $KSROOT/bin/cos
else
	cp -rf /tmp/cos/bin/cos $KSROOT/bin/cos
fi
cp -rf /tmp/cos/scripts/* $KSROOT/scripts/
cp -rf /tmp/cos/init.d/* $KSROOT/init.d/
cp -rf /tmp/cos/webs/* $KSROOT/webs/
cp /tmp/cos/uninstall.sh $KSROOT/scripts/uninstall_cos.sh

chmod +x $KSROOT/bin/tgt*
chmod +x $KSROOT/scripts/cos_*
chmod +x $KSROOT/init.d/S99cos.sh

dbus set softcenter_module_cos_description=软件中心自动云备份和恢复
dbus set softcenter_module_cos_install=1
dbus set softcenter_module_cos_name=cos
dbus set softcenter_module_cos_title=腾讯云存储
dbus set softcenter_module_cos_version=0.1

sleep 1
rm -rf /tmp/cos* >/dev/null 2>&1
