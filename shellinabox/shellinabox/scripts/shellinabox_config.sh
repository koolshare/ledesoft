#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export shellinabox_`

fix_libssl() {
	libssl=$(find /lib /usr/lib -name "libssl.so*" -type f)
	if [ -n "$libssl" ];then
		dir=$(dirname $libssl)
		libssl=$(basename $libssl)

		cd $dir
		[ ! -f libssl.so ] && ln -s $libssl libssl.so
		cd - > /dev/null
	fi
}

start_shellinabox(){
	if [ "$shellinabox_style" == "1" ];then
		$KSROOT/shellinabox/shellinaboxd -u root -c /koolshare/shellinabox --css=/koolshare/shellinabox/black-on-white.css -t -b
	else
		$KSROOT/shellinabox/shellinaboxd -u root -c /koolshare/shellinabox --css=/koolshare/shellinabox/white-on-black.css -t -b
	fi
}


case $2 in
check)
	RUN=`pidof shellinaboxd`
	[ -z "$RUN" ] && fix_libssl && start_shellinabox
	;;
restart)
	killall shellinaboxd
	fix_libssl
	start_shellinabox
	http_response "$1"
	;;
esac
