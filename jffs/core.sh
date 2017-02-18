#!/bin/sh
export PERP_BASE=/jffs/koolshare/perp
export PATH=/jffs/koolshare/bin:/jffs/koolshare/scripts:/usr/bin:/sbin:/bin:/usr/sbin

#启动环境服务
rm -f /tmp/skpid.pid
rm -f /tmp/httpdb.pid
cd /jffs/koolshare
chmod 755 /jffs/koolshare/bin/*
chmod 755 /jffs/koolshare/scripts/*
/jffs/koolshare/bin/skipd &

#劫持默认端口并重启生效
lanip=$(nvram get lan_ipaddr)

#80
lanport=$(nvram get http_lanport) 
if [ "$lanport" != "9527" ]; then
nvram set http_lanport1=$lanport
nvram set http_lanport=9527
nvram commit
service httpd restart
fi

lanport1=$(nvram get http_lanport1)
/jffs/koolshare/bin/httpdb -p $lanport1 -r $lanip:9527 -w /jffs/koolshare/webs >/tmp/httpdb.pid 2>&1 &

#初始化软件中心
if [ `dbus get softcenter_version` == "" ]; then
dbus set softcenter_version=0.0.0
fi
