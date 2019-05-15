#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export usbmount`

confs=`dbus list usbmount|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/usbmount*
rm -rf $KSROOT/webs/Module_usbmount.asp
rm -rf $KSROOT/webs/res/icon-usbmount.png
rm -rf $KSROOT/webs/res/icon-usbmount-bg.png

sed -i '/usbmount/d' /lib/upgrade/keep.d/fwupdate >/dev/null 2>&1 &

dbus remove softcenter_module_usbmount_home_url
dbus remove softcenter_module_usbmount_install
dbus remove softcenter_module_usbmount_md5
dbus remove softcenter_module_usbmount_version
dbus remove softcenter_module_usbmount_name
dbus remove softcenter_module_usbmount_description
