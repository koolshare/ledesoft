#! /bin/sh
export KSROOT=/koolshare
confs=`dbus list memory|cut -d "=" -f1`
for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/memory*
rm -rf $KSROOT/webs/Module_memory.asp
rm -rf $KSROOT/init.d/S98memory.sh
rm -rf /etc/rc.d/S98memory.sh
rm -rf $KSROOT/webs/res/icon-memory.png
rm -rf $KSROOT/webs/res/icon-memory-bg.png

dbus remove softcenter_module_memory_home_url
dbus remove softcenter_module_memory_install
dbus remove softcenter_module_memory_md5
dbus remove softcenter_module_memory_version
dbus remove softcenter_module_memory_name
dbus remove softcenter_module_memory_description

rm -rf $KSROOT/scripts/uninstall_memory.sh
