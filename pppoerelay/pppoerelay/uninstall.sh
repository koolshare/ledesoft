#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export pppoerelay`

confs=`dbus list pppoerelay|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/bin/pppoe-relay
rm -rf $KSROOT/scripts/pppoerelay*
rm -rf $KSROOT/init.d/S97pppoerelay.sh
rm -rf /etc/rc.d/S97pppoerelay.sh
rm -rf $KSROOT/webs/Module_pppoerelay.asp
rm -rf $KSROOT/webs/res/icon-pppoerelay.png
rm -rf $KSROOT/webs/res/icon-pppoerelay-bg.png

dbus remove softcenter_module_pppoerelay_home_url
dbus remove softcenter_module_pppoerelay_install
dbus remove softcenter_module_pppoerelay_md5
dbus remove softcenter_module_pppoerelay_version
dbus remove softcenter_module_pppoerelay_name
dbus remove softcenter_module_pppoerelay_description
