#! /bin/sh
cd /tmp
cp -rf /tmp/aria2/aria2 /jffs/koolshare/
cp -rf /tmp/aria2/res/* /jffs/koolshare/res/
cp -rf /tmp/aria2/scripts/* /jffs/koolshare/scripts/
cp -rf /tmp/aria2/webs/* /jffs/koolshare/webs/
cp -rf /tmp/aria2/perp/aria2 /jffs/koolshare/perp/



cd /
rm -rf /tmp/aria2* >/dev/null 2>&1


if [ -L /jffs/koolshare/init.d/S91aria2 ];then
	ln -sf /jffs/koolshare/aria2/aria2_run.sh /jffs/koolshare/init.d/S91aria2.sh
fi


if [ ! -f /jffs/koolshare/aria2/aria2.session ];then
	touch /jffs/koolshare/aria2/aria2.session
fi


if [ -f /jffs/koolshare/scripts/aria2_run.sh ];then
	rm -rf /jffs/koolshare/scripts/aria2_run.sh
fi


chmod 755 /jffs/koolshare/aria2/*
chmod 755 /jffs/koolshare/init.d/*
chmod 755 /jffs/koolshare/scripts/aria2*
chmod 755 /jffs/koolshare/perp/aria2/*

dbus set softcenter_module_aria2_install=1
dbus set softcenter_module_aria2_version=0.1
dbus set softcenter_module_aria2_description="aria2下载工具"

