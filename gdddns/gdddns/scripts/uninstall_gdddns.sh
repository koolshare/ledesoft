#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

rm -rf /etc/rc.d/S98gdddns.sh > /dev/null 2>&1
rm -rf $KSROOT/bin/gdddns_curl > /dev/null 2>&1
rm -rf $KSROOT/webs/res/icon-gdddns.png > /dev/null 2>&1
rm -rf $KSROOT/webs/Module_gdddns.asp > /dev/null 2>&1
rm -rf $KSROOT/scripts/gdddns_* > /dev/null 2>&1
rm -rf $KSROOT/scripts/uninstall_gdddns.sh > /dev/null 2>&1
rm -rf $KSROOT/init.d/S98gddns.sh > /dev/null 2>&1
rm -rf /etc/hotplug.d/iface/98-gdddns

dbus remove softcenter_module_gdddns_home_url
dbus remove softcenter_module_gdddns_install
dbus remove softcenter_module_gdddns_md5
dbus remove softcenter_module_gdddns_version
dbus remove softcenter_module_gdddns_name
dbus remove softcenter_module_gdddns_title
dbus remove softcenter_module_gdddns_description