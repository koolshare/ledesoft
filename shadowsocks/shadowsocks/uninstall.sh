#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

sh $KSROOT/scripts/ss_conf.sh 1 1
sleep 1
rm -rf $KSROOT/ss
rm -rf $KSROOT/scripts/ss_*
rm -rf $KSROOT/webs/Module_shadowsocks.asp
rm -rf $KSROOT/bin/ss-tunnel
rm -rf $KSROOT/bin/ss-local
rm -rf $KSROOT/bin/ss-server
rm -rf $KSROOT/bin/ss-redir
rm -rf $KSROOT/bin/rss*
rm -rf $KSROOT/bin/obfs*
rm -rf $KSROOT/bin/pdnsd
rm -rf $KSROOT/bin/Pcap_DNSProxy
rm -rf $KSROOT/bin/dnscrypt-proxy
rm -rf $KSROOT/bin/dns2socks
rm -rf $KSROOT/bin/chinadns
rm -rf $KSROOT/bin/resolveip
rm -rf $KSROOT/bin/busybox
rm -rf $KSROOT/bin/ps
rm -rf /usr/lib/lua/luci/controller/sadog.lua
rm -rf /tmp/luci-*

dbus remove softcenter_module_shadowsocks_home_url
dbus remove softcenter_module_shadowsocks_install
dbus remove softcenter_module_shadowsocks_md5
dbus remove softcenter_module_shadowsocks_version
