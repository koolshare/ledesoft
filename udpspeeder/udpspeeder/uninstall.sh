#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export udpspeeder_`

# stop udpspeeder if enabled
[ -n "`pidof UDPspeeder`" ] && sh $KSROOT/scripts/udpspeeder_config.sh stop

# remove dbus data in softcenter
confs=`dbus list udpspeeder_|cut -d "=" -f1`
for conf in $confs
do
	dbus remove $conf
done

# remove files
rm -rf $KSROOT/bin/UDPspeeder*
rm -rf $KSROOT/scripts/udpspeeder*
rm -rf $KSROOT/init.d/S99udpspeeder.sh
rm -rf /etc/rc.d/S99udpspeeder.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_udpspeeder.asp
rm -rf $KSROOT/webs/res/icon-udpspeeder.png
rm -rf $KSROOT/webs/res/icon-udpspeeder-bg.png

# remove skipd data of udpspeeder
dbus remove softcenter_module_udpspeeder_home_url
dbus remove softcenter_module_udpspeeder_install
dbus remove softcenter_module_udpspeeder_md5
dbus remove softcenter_module_udpspeeder_version
dbus remove softcenter_module_udpspeeder_name
dbus remove softcenter_module_udpspeeder_title
dbus remove softcenter_module_udpspeeder_description