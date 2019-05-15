#! /bin/sh
export KSROOT=/koolshare

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

case $ACTION in
start)
	killall shellinaboxd
	fix_libssl
	$KSROOT/shellinabox/shellinaboxd -u root -c /koolshare/shellinabox --css=/koolshare/shellinabox/white-on-black.css -t -b
	;;
stop)
	killall shellinaboxd
	;;
*)
	killall shellinaboxd
	fix_libssl
	$KSROOT/shellinabox/shellinaboxd -u root -c /koolshare/shellinabox --css=/koolshare/shellinabox/white-on-black.css -t -b
	;;
esac