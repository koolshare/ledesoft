#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export hotfix`

cd /tmp
cp -rf /tmp/hotfix/webs/* $KSROOT/webs/
cp /tmp/hotfix/uninstall.sh $KSROOT/scripts/uninstall_hotfix.sh

# 为新安装文件赋予执行权限...
dbus set softcenter_module_hotfix_install=1
dbus set softcenter_module_hotfix_name=hotfix
dbus set softcenter_module_hotfix_title=HOTFIX
dbus set softcenter_module_hotfix_version=0.1
dbus set softcenter_module_hotfix_description="无疼修复当前固件中的BUG"

# ====================== fix start ===============================
version_local=`cat /etc/openwrt_release|grep DISTRIB_RELEASE|cut -d "'" -f 2|cut -d "V" -f 2`

# hotfix ss status
if [ "$version_local" == "2.0" ];then
	sed -i '/google.com.tw/d' /etc/dnsmasq.d/gfwlist.conf >/dev/null 2>&1 &
	sed -i '/google.com.tw/d' /etc/dnsmasq.d/custom.conf >/dev/null 2>&1 &
	sed -i '/google.com.tw/d' /etc/gfwlist/gfwlist >/dev/null 2>&1 &
	rm -rf /tmp/dnsmasq.d/custom.conf
	rm -rf /tmp/dnsmasq.d/gfwlist.conf
	/etc/init.d/shadowsocks restart
fi

# host fix for 2.2 firmware for ssr onlineconfig (2017-8-25 16:42:18)
if [ "$version_local" == "2.1" ] || [ "$version_local" == "2.2" ];then
	MD5_1=`md5sum /tmp/hotfix/hotfix/2.2_onlineconfig | awk '{print $1}'`
	MD5_2=`md5sum /usr/share/shadowsocks/onlineconfig | awk '{print $1}'`
	if [ "$MD5_1" != "MD5_2" ];then
		cp -rf /tmp/hotfix/hotfix/2.2_onlineconfig /usr/share/shadowsocks/onlineconfig
		chmod +x /usr/share/shadowsocks/onlineconfig
	fi
fi

# fix softcenter blank
if [ "$version_local" == "2.1" ] || [ "$version_local" == "2.2" ];then
	ERR_LEN=`cat /etc/init.d/softcenter |grep killall|wc -c`
	if [ "$ERR_LEN" == "40" ];then
		sed -i '34s/ &$//g' /etc/init.d/softcenter
	fi
fi

# fix 2.12 ss-redir libsodium
if [ "$version_local" == "2.12" ];then
	ln -s /usr/lib/libsodium.so.23.1.0 /usr/lib/libsodium.so.18
fi

# fix init.d start up scripts lost
/bin/ls -L /etc/rc.d/*.sh >/dev/null 2>&1
if [ "$?" != "0" ];then
	cd /etc/rc.d
	FILES=`ls -Fp *.sh|sed 's/@//g'`
	for file in $FILES
	do
		name=`echo $file|sed 's/^...//'|sed 's/.sh//g'`
		wget -O- "https://ledesoft.ngrok.wang/$name/$name/init.d/$file" >/koolshare/init.d/$file
	done
	chmod +x /koolshare/init.d/*
fi

# host fix for firmware under 2.14 for flock missing (2018-4-23 16:56:10)
if [ "`/koolshare/bin/versioncmp $version_local 2.14`" == "1" ];then
	if [ -z "`which flock`" ];then
		cd /tmp/hotfix/hotfix
		chmod +x flock_2.32-1_x86_64.ipk
		opkg install ./flock_2.32-1_x86_64.ipk
	fi
fi

# host fix for firmware under 2.17 for flock missing (2018-4-23 16:56:10)
if [ "$version_local" == "2.17" ];then
		cp -r /tmp/hotfix/hotfix/realtimetraffic.htm /usr/lib/lua/luci/view/admin_status/realtimetraffic.htm
		rm -rf /tmp/luci-*
fi

# host fix for firmware under 2.26 for ATT Theme Chinese localization (2019-1-1 23:35:10)
if [ "$version_local" == "2.26" ];then
		sed '206 i<script src="<%=url("'admin/translations'", luci.i18n.context.lang)%><%# ?v=PKG_VERSION %>"></script>' -i /usr/lib/lua/luci/view/themes/advancedtomato/header.htm
fi

# host fix for firmware 2.30 opkg check filed (2019-3-10 11:15:10)
if [ "$version_local" == "2.30" ];then
	sed -i 's/openwrt.proxy.ustclug.org/downloads.openwrt.org/g' /etc/opkg/distfeeds.conf
fi

# ====================== fix end ===============================

sleep 1
rm -rf /tmp/hotfix* >/dev/null 2>&1
