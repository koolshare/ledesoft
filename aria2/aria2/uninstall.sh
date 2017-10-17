#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export aria2`

rm -rf /koolshare/aria2
rm -rf /koolshare/scripts/aria2*
rm -rf /koolshare/webs/Module_aria2.asp
rm -rf /etc/rc.d/S96aria2.sh

for r in `dbus list aria2|cut -d"=" -f 1`
do
	dbus remove $r
done

dbus remove softcenter_module_aria2_home_url
dbus remove softcenter_module_aria2_install
dbus remove softcenter_module_aria2_md5
dbus remove softcenter_module_aria2_version
dbus remove softcenter_module_aria2_name
dbus remove softcenter_module_aria2_description

rm -rf $KSROOT/scripts/uninstall_aria2.sh
