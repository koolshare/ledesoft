#! /bin/sh

if [ -z $KSROOT ]; then
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
fi
			
cp -rf /tmp/shellinabox/shellinabox $KSROOT/
cp -rf /tmp/shellinabox/res/* $KSROOT/res/
cp -rf /tmp/shellinabox/webs/* $KSROOT/webs
chmod 755 $KSROOT/shellinabox/*	
killall shellinaboxd
sleep 1
sh $KSROOT/shellinabox/shellinabox_start.sh
dbus set __event__onwanstart_shellinlinux=$KSROOT/shellinabox/shellinabox_start.sh

rm -rf /tmp/shellinabox*
	
