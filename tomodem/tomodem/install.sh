#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export tomodem_`

cp -rf /tmp/tomodem/scripts/* $KSROOT/scripts/
cp -rf /tmp/tomodem/webs/* $KSROOT/webs/
cp /tmp/tomodem/uninstall.sh $KSROOT/scripts/uninstall_tomodem.sh

chmod +x $KSROOT/scripts/tomodem_*

dbus set softcenter_module_tomodem_description=路由拨号后访问光猫
dbus set softcenter_module_tomodem_install=1
dbus set softcenter_module_tomodem_name=tomodem
dbus set softcenter_module_tomodem_title="光猫助手"
dbus set softcenter_module_tomodem_version=0.1

sleep 1
rm -rf /tmp/tomodem* >/dev/null 2>&1
