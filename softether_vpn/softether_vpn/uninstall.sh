#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export softether`

enable=`dbus get softether_enable`
if [ "$enable" == 1 ];then
	sh $KSROOT/softether/softether.sh stop
fi

dbus remove softether_enable
dbus remove softether_l2tp
dbus remove softether_openvpn
dbus remove softether_sstp

sleep 1
rm -rf $KSROOT/softether
rm -rf $KSROOT/scripts/softether*
rm -rf $KSROOT/init.d/S96softether.sh
rm -rf $KSROOT/webs/Module_softether_vpn.asp

dbus remove softcenter_module_softether_home_url
dbus remove softcenter_module_softether_install
dbus remove softcenter_module_softether_md5
dbus remove softcenter_module_softether_version
dbus remove softcenter_module_softether_name
dbus remove softcenter_module_softether_description
