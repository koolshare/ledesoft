#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export softether`
fwlocal=`cat /etc/openwrt_release|grep DISTRIB_RELEASE|cut -d "'" -f 2|cut -d "V" -f 2`
checkversion=`versioncmp $fwlocal 2.30`

mkdir -p $KSROOT/softether
mkdir -p $KSROOT/init.d
mkdir -p /tmp/upload

# remove useless rule if old version
sed -i '/softether.sh/d' /etc/firewall.user >/dev/null 2>&1

enable=`dbus get softether_enable`
if [ -f "$KSROOT/softether/vpn_server.config" ];then
	tap=`cat $KSROOT/softether/vpn_server.config |grep "bool TapMode true"`
else
	tap=""
fi

if [ "$enable" == 1 ];then
	sh $KSROOT/softether/softether.sh stop
fi

# copy new files
cd /tmp
if [ "$checkversion" == "1" ]; then
	cp -rf /tmp/softether_vpn/softether/1-hamcore.se2 $KSROOT/softether/hamcore.se2
	cp -rf /tmp/softether_vpn/softether/1-vpnserver $KSROOT/softether/vpnserver
else
	cp -rf /tmp/softether_vpn/softether/hamcore.se2 $KSROOT/softether/
	cp -rf /tmp/softether_vpn/softether/vpnserver $KSROOT/softether/
fi
cp -rf /tmp/softether_vpn/softether/softether.sh $KSROOT/softether/
cp -rf /tmp/softether_vpn/scripts/* $KSROOT/scripts/
cp -rf /tmp/softether_vpn/init.d/* $KSROOT/init.d/
cp -rf /tmp/softether_vpn/webs/* $KSROOT/webs/
cp /tmp/softether_vpn/uninstall.sh $KSROOT/scripts/uninstall_softether_vpn.sh

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/softether/*
chmod 755 $KSROOT/scripts/softether*

# make some link
[ ! -L "/etc/rc.d/S96softether.sh" ] && ln -sf $KSROOT/init.d/S96softether.sh /etc/rc.d/S96softether.sh

# remove install pockage
sleep 1
rm -rf /tmp/softether* >/dev/null 2>&1

# reenable softether_vpn
if [ "$enable" == 1 ] && [ -n "$tap" ];then
	sh $KSROOT/softether/softether.sh restart
fi

