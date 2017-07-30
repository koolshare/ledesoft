#! /bin/sh

if [ -z $KSROOT ]; then
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
fi
			
cp -rf /tmp/shellinabox/shellinabox $KSROOT/
cp -rf /tmp/shellinabox/webs/* $KSROOT/webs/
cp -rf /tmp/shellinabox/scripts/* $KSROOT/scripts/
chmod 755 $KSROOT/shellinabox/*	
chmod 755 $KSROOT/scripts/*	
killall shellinaboxd
sleep 1
sh $KSROOT/shellinabox/shellinabox_start.sh

rm -rf /tmp/shellinabox*