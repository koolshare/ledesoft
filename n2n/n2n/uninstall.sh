#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export n2n`

confs=`dbus list n2n|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/n2n*
rm -rf $KSROOT/bin/edge
rm -rf $KSROOT/bin/supernode
rm -rf $KSROOT/init.d/S99n2n.sh
rm -rf /etc/rc.d/S99n2n.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_n2n.asp
rm -rf $KSROOT/webs/res/icon-n2n.png
rm -rf $KSROOT/webs/res/icon-n2n-bg.png

dbus remove softcenter_module_n2n_home_url
dbus remove softcenter_module_n2n_install
dbus remove softcenter_module_n2n_md5
dbus remove softcenter_module_n2n_version
dbus remove softcenter_module_n2n_name
dbus remove softcenter_module_n2n_description

rm -rf $KSROOT/scripts/uninstall_n2n.sh
