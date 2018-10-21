#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export lnmp_`

mkdir -p $KSROOT/init.d
mkdir -p $KSROOT/lnmp
cd /tmp
cp -rf /tmp/lnmp/lnmp/* $KSROOT/lnmp/
cp -rf /tmp/lnmp/scripts/* $KSROOT/scripts/
cp -rf /tmp/lnmp/init.d/* $KSROOT/init.d/
cp -rf /tmp/lnmp/webs/* $KSROOT/webs/
cp /tmp/lnmp/uninstall.sh $KSROOT/scripts/uninstall_lnmp.sh

chmod +x $KSROOT/scripts/lnmp_*
chmod +x $KSROOT/init.d/S99lnmp.sh

dbus set softcenter_module_lnmp_description=自动化部署WEB环境
dbus set softcenter_module_lnmp_install=1
dbus set softcenter_module_lnmp_name=lnmp
dbus set softcenter_module_lnmp_title=LNMP
dbus set softcenter_module_lnmp_version=0.1

sleep 1
rm -rf /tmp/lnmp* >/dev/null 2>&1
