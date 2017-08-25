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

# hotfix start
sed -i '/google.com.tw/d' /etc/dnsmasq.d/gfwlist.conf >/dev/null 2>&1 &
sed -i '/google.com.tw/d' /etc/dnsmasq.d/custom.conf >/dev/null 2>&1 &
sed -i '/google.com.tw/d' /etc/gfwlist/gfwlist >/dev/null 2>&1 &
rm -rf /tmp/dnsmasq.d/custom.conf
rm -rf /tmp/dnsmasq.d/gfwlist.conf
/etc/init.d/shadowsocks restart
sleep 1
rm -rf /tmp/hotfix* >/dev/null 2>&1

# host fix for 2.2 firmware for ssr onlineconfig
version_local=`cat /etc/openwrt_release|grep DISTRIB_RELEASE|cut -d "'" -f 2|cut -d "V" -f 2`
[ "$version_local" == "2.1" ] || [ "$version_local" == "2.2" ] && cp -rf /tmp/hotfix/hotfix/2.2_onlineconfig /usr/share/shadowsocks/onlineconfig










