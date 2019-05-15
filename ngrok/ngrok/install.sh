#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

rm -rf $KSROOT/scripts/ngrok_*
rm -rf /etc/rc.d/S99ngrok.sh
rm -rf $KSROOT/web/res/icon-ngrok*
rm -rf $KSROOT/web/Module_ngrok.asp

cp -r /tmp/ngrok/* $KSROOT/
chmod a+x $KSROOT/scripts/ngrok_*

if [ ! -L "/etc/rc.d/S99ngrok.sh" ]; then 
	ln -sf $KSROOT/scripts/ngrok_config.sh /etc/rc.d/S99ngrok.sh
fi

# add icon into softerware center
dbus set softcenter_module_ngrok_install=1
dbus set softcenter_module_ngrok_version=0.1
dbus set softcenter_module_ngrok_description="Ngrok"
dbus set ngrok_srlist='';
rm -rf /tmp/ngrok
