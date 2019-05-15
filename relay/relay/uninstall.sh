#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export relay`

confs=`dbus list relay|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/relay_*
rm -rf $KSROOT/webs/Module_relay.asp
rm -rf $KSROOT/webs/res/icon-relay.png
rm -rf $KSROOT/webs/res/icon-relay-bg.png
rm -rf $KSROOT/bin/socat
rm -rf $KSROOT/init.d/S99relay.sh
rm -rf /etc/rc.d/S99relay.sh

dbus remove softcenter_module_relay_home_url
dbus remove softcenter_module_relay_install
dbus remove softcenter_module_relay_md5
dbus remove softcenter_module_relay_version
dbus remove softcenter_module_relay_name
dbus remove softcenter_module_relay_description

rm -rf $KSROOT/scripts/uninstall_relay.sh
