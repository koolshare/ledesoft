#!/bin/sh

if [ -z $KSROOT ]; then
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
fi

#dbus set softcenter_home_url="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui"
#dbus set softcenter_home_url="https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui"
dbus set softcenter_home_url="https://ttsoft.ngrok.wang"


#test001, normal installing
#dbus remove shellinabox_version
#dbus remove shellinabox_md5

#export softcenter_installing_module
#export softcenter_installing_tick
export softcenter_installing_todo=shellinabox
export softcenter_installing_version=1.4
export softcenter_installing_md5=655870d2f498d346942d9991e1404a35
export softcenter_installing_tar_url="shellinabox/shellinabox.tar.gz"
dbus save softcenter_installing

sh $KSROOT/scripts/ks_app_install.sh

rlt=`dbus get softcenter_installing_status`
if [ "$rlt" != "1" ]; then
	echo "test001 failed"
	exit
fi
