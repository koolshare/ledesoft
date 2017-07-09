#! /bin/sh

sh /koolshare/aria2/aria2_run.sh stop
rm -rf /koolshare/aria2
rm -rf /koolshare/scripts/aria2_config.sh
rm -rf /koolshare/webs/Module_aria2.asp
rm -rf /etc/rc.d/S91aria2.sh

for r in `dbus list aria2|cut -d"=" -f 1`
do
	dbus remove $r
done
