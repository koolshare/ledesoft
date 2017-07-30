#! /bin/sh

killall shellinaboxd
sleep 1	
rm -rf $KSROOT/webs/res/icon-shellinabox*
rm -rf $KSROOT/webs/Module_shellinabox.asp
rm -rf $KSROOT/scripts/shellinabox_config.sh
rm -rf $KSROOT/shellinabox
rm -rf /etc/rc.d/S99shellinabox*
