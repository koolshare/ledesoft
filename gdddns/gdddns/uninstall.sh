#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export gdddns`

# remove dbus data in softcenter
confs=`dbus list gdddns|cut -d "=" -f1`
for conf in $confs
do
	dbus remove $conf
done

rm -rf $KSROOT/scripts/gdddns*
rm -rf $KSROOT/webs/Module_gdddns.asp
rm -rf $KSROOT/webs/res/icon-gdddns*
rm -rf $KSROOT/init.d/S98gddns.sh
find /etc/rc.d/ -name *gdddns.sh* | xargs rm -rf

# remove dbus data in gddns
dbus remove softcenter_module_gddns_home_url
dbus remove softcenter_module_gddns_install
dbus remove softcenter_module_gddns_md5
dbus remove softcenter_module_gddns_version
dbus remove softcenter_module_gddns_name
dbus remove softcenter_module_gddns_title
dbus remove softcenter_module_gddns_description