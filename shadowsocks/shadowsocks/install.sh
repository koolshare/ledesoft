#! /bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

# 关闭ss
mkdir -p $KSROOT/ss
if [ "$ss_basic_enable" == "1" ];then
	echo_date 先关闭ss，保证文件更新成功!
	sh $KSROOT/ss/start.sh stop
fi

#升级前先删除无关文件
echo_date 清理旧文件
rm -rf $KSROOT/ss/*  >/dev/null 2>&1
rm -rf $KSROOT/scripts/ss_*  >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_shadowsocks.asp  >/dev/null 2>&1
rm -rf $KSROOT/bin/ss-tunnel  >/dev/null 2>&1
rm -rf $KSROOT/bin/ss-local  >/dev/null 2>&1
rm -rf $KSROOT/bin/ss-redir >/dev/null 2>&1
rm -rf $KSROOT/bin/rss* >/dev/null 2>&1
rm -rf $KSROOT/bin/pdnsd >/dev/null 2>&1
rm -rf $KSROOT/bin/Pcap_DNSProxy >/dev/null 2>&1
rm -rf $KSROOT/bin/dnscrypt-proxy >/dev/null 2>&1
rm -rf $KSROOT/bin/dns2socks >/dev/null 2>&1
rm -rf $KSROOT/bin/chinadns >/dev/null 2>&1
rm -rf $KSROOT/bin/resolveip >/dev/null 2>&1

cd /tmp
cp -rf /tmp/shadowsocks/bin/* $KSROOT/bin/
cp -rf /tmp/shadowsocks/ss/* $KSROOT/ss/
cp -rf /tmp/shadowsocks/scripts/* $KSROOT/scripts/
cp -rf /tmp/shadowsocks/webs/* $KSROOT/webs/
cp -rf /tmp/shadowsocks/res/* $KSROOT/res/

cp /tmp/shadowsocks/install.sh $KSROOT/scripts/ss_install.sh
cp /tmp/shadowsocks/uninstall.sh $KSROOT/scripts/uninstall_shadowsocks.sh

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/bin/*
chmod 755 $KSROOT/ss/dns/dns.sh
chmod 755 $KSROOT/ss/start.sh
chmod 755 $KSROOT/scripts/ss_*
chmod 755 $KSROOT/scripts/pcap_*

dbus set ss_basic_version=`cat $KSROOT/ss/version`

sleep 1
rm -rf /tmp/shadowsocks* >/dev/null 2>&1

if [ "$ss_basic_enable" == "1" ];then
	echo_date 重启ss！
	sh $KSROOT/ss/start.sh start_all
fi








