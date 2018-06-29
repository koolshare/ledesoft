#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export ngrok`

confs=`dbus list ngrok|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/bin/ngrok
rm -rf $KSROOT/scripts/ngrok*
rm -rf $KSROOT/webs/Module_ngrok.asp
rm -rf $KSROOT/webs/res/icon-ngrok.png
rm -rf $KSROOT/webs/res/icon-ngrok-bg.png
rm -rf /etc/rc.d/S99ngrok.sh

dbus remove softcenter_module_ngrok_home_url
dbus remove softcenter_module_ngrok_install
dbus remove softcenter_module_ngrok_md5
dbus remove softcenter_module_ngrok_version
dbus remove softcenter_module_ngrok_name
dbus remove softcenter_module_ngrok_description
