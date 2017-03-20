#! /bin/sh

if [ ! -L "$KSROOT/init.d/S99Shellinabox.sh" ]; then 
	ln -sf $KSROOT/shellinabox/shellinabox_start.sh $KSROOT/init.d/S99Shellinabox.sh
fi
case $ACTION in
start)
	killall shellinaboxd
	$KSROOT/shellinabox/shellinaboxd --css=/jffs/koolshare/shellinabox/white-on-black.css -b
	;;
stop)
	killall shellinaboxd
	;;
*)
	killall shellinaboxd
	$KSROOT/shellinabox/shellinaboxd --css=/jffs/koolshare/shellinabox/white-on-black.css -b
	;;
esac
