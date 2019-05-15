#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export autocheckin`

confs=`dbus list autocheckin|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/autocheckin*
rm -rf $KSROOT/init.d/S95autocheckin.sh
rm -rf $KSROOT/autocheckin
rm -rf $KSROOT/webs/Module_autocheckin.asp
rm -rf $KSROOT/webs/res/icon-autocheckin.png
rm -rf $KSROOT/webs/res/icon-autocheckin-bg.png
rm -rf /etc/rc.d/S95autocheckin.sh >/dev/null 2>&1

dbus remove softcenter_module_autocheckin_home_url
dbus remove softcenter_module_autocheckin_install
dbus remove softcenter_module_autocheckin_md5
dbus remove softcenter_module_autocheckin_version
dbus remove softcenter_module_autocheckin_name
dbus remove softcenter_module_autocheckin_description
rm -rf $KSROOT/scripts/uninstall_autocheckin.sh
