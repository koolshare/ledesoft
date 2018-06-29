#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export serverchan`

# stop first
/koolshare/scripts/serverchan_config ks stop

# remove dbus data in softcenter
confs=`dbus list serverchan|cut -d "=" -f1`
for conf in $confs
do
	dbus remove $conf
done

# remove files
rm -rf $KSROOT/scripts/serverchan*
rm -rf $KSROOT/webs/Module_serverchan.asp
rm -rf $KSROOT/webs/res/icon-serverchan.png
rm -rf $KSROOT/webs/res/icon-serverchan-bg.png

# remove dbus data in serverchan
dbus remove softcenter_module_serverchan_home_url
dbus remove softcenter_module_serverchan_install
dbus remove softcenter_module_serverchan_md5
dbus remove softcenter_module_serverchan_version
dbus remove softcenter_module_serverchan_name
dbus remove softcenter_module_serverchan_title
dbus remove softcenter_module_serverchan_description