#! /bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export webshell`

killall webshell
dbus remove webshell_cols
dbus remove webshell_rows
dbus remove webshell_style

sleep 1
rm -rf $KSROOT/bin/webshell
rm -rf $KSROOT/scripts/webshell_*
rm -rf $KSROOT/webs/Module_webshell.asp

dbus remove softcenter_module_webshell_home_url
dbus remove softcenter_module_webshell_install
dbus remove softcenter_module_webshell_md5
dbus remove softcenter_module_webshell_version
dbus remove softcenter_module_webshell_name
dbus remove softcenter_module_webshell_description
