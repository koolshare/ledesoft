#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

rm -rf $KSROOT/scripts/ngrok_*
rm -rf $KSROOT/init.d/S99ngrok.sh
rm -rf $KSROOT/res/icon-ngrok*
rm -rf $KSROOT/web/Module_ngrok.asp

cp -r /tmp/ngrok/* $KSROOT/
chmod a+x $KSROOT/scripts/ngrok_*

# add icon into softerware center
dbus set softcenter_module_ngrok_install=1
dbus set softcenter_module_ngrok_version=0.4
dbus set softcenter_module_ngrok_description="阿里云解析自动更新IP"
dbus set ngrok_srlist='';
rm -rf $KSROOT/install.sh
