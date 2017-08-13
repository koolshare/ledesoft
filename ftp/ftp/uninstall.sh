#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export ftp`

confs=`dbus list ftp|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/ftp
rm -rf $KSROOT/scripts/ftp*
rm -rf $KSROOT/init.d/S94ftp.sh
rm -rf /etc/rc.d/S94ftp.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_ftp.asp
rm -rf $KSROOT/webs/res/icon-ftp.png
rm -rf $KSROOT/webs/res/icon-ftp-bg.png

dbus remove softcenter_module_ftp_home_url
dbus remove softcenter_module_ftp_install
dbus remove softcenter_module_ftp_md5
dbus remove softcenter_module_ftp_version
dbus remove softcenter_module_ftp_name
dbus remove softcenter_module_ftp_description
