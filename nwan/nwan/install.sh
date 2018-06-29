#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export nwan_`

mkdir -p $KSROOT/nwan
cp -rf /tmp/nwan/nwan/* $KSROOT/nwan/
cp -rf /tmp/nwan/scripts/* $KSROOT/scripts/
cp -rf /tmp/nwan/webs/* $KSROOT/webs/
cp /tmp/nwan/uninstall.sh $KSROOT/scripts/uninstall_nwan.sh

chmod +x $KSROOT/scripts/nwan_*

dbus set softcenter_module_nwan_description=宽带并发多拨
dbus set softcenter_module_nwan_install=1
dbus set softcenter_module_nwan_name=nwan
dbus set softcenter_module_nwan_title="多线多拨"
dbus set softcenter_module_nwan_version=0.1

[ -z "$nwan_tarckip" ] && dbus set nwan_tarckip="114.114.114.114 119.29.29.29 taobao.com www.baidu.com"
[ -z "$nwan_config" ] && dbus set nwan_config=1

sleep 1
rm -rf /tmp/nwan >/dev/null 2>&1
