#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export swap`

confs=`dbus list swap|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/swap*
rm -rf $KSROOT/webs/Module_swap.asp

dbus remove softcenter_module_swap_home_url
dbus remove softcenter_module_swap_install
dbus remove softcenter_module_swap_md5
dbus remove softcenter_module_swap_version
dbus remove softcenter_module_swap_name
dbus remove softcenter_module_swap_description
