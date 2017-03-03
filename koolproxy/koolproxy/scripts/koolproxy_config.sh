#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export koolproxy_`

# echo $1 > /jffs/test.txt
# echo $2 >> /jffs/test.txt
# echo koolproxy_open: $koolproxy_open >> /jffs/test.txt
# echo koolproxy_mode: $koolproxy_mode >> /jffs/test.txt
# echo koolproxy_update: $koolproxy_update >> /jffs/test.txt
# echo koolproxy_update_time: $koolproxy_update_time >> /jffs/test.txt
# echo koolproxy_restart: $koolproxy_restart >> /jffs/test.txt
# echo koolproxy_restart_time: $koolproxy_restart_time >> /jffs/test.txt
# echo koolproxy_acl_method: $koolproxy_acl_method >> /jffs/test.txt

case $2 in
1)
	touch /jffs/test1111.txt
	;;
2)
	touch /jffs/test3333.txt
	;;
*)
	touch /jffs/test4444.txt
	;;
esac
#http_response "2222222"

sleep 3
http_response "$1"

