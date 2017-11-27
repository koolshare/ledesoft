#! /bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export ss`
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

# 判断路由架构和平台
case $(uname -m) in
  armv7l)
  	echo_date 本插件用于koolshare lede x86_64固件平台，arm平台不能安装！！！
  	echo_date 退出安装！
    exit 0
    ;;
  mips)
  	echo_date 本插件用于koolshare lede x86_64固件平台，mips平台不能安装！！！
  	echo_date 退出安装！
    exit 0
    ;;
  x86_64)
  	fw867=`cat /etc/banner|grep fw867`
  	if [ -d "/koolshare" ] && [ -n "$fw867" ];then
		echo_date 固件平台【koolshare lede x86_64】符合安装要求，开始安装插件！
    else
		echo_date 本插件用于koolshare lede x86_64固件平台，其它x86_64固件平台不能安装！！！
		exit 0
    fi
    ;;
  *)
  	echo_date 本插件用于koolshare lede x86_64固件平台，其它平台不能安装！！！
  	echo_date 退出安装！
    exit 0
    ;;
esac

# 准备
echo_date 创建相关文件夹...
mkdir -p $KSROOT/ss
mkdir -p $KSROOT/init.d

# 关闭ss
if [ "$ss_basic_enable" == "1" ];then
	echo_date 先关闭ss，保证文件更新成功!
	[ -f "$KSROOT/ss/ssstart.sh" ] && sh $KSROOT/ss/ssstart.sh stop
fi

#升级前先删除无关文件
echo_date 清可能存在的理旧文件...
rm -rf $KSROOT/ss/*  >/dev/null 2>&1
rm -rf $KSROOT/init.d/S99shadowsocks.sh >/dev/null 2>&1
rm -rf $KSROOT/init.d/S99koolss.sh >/dev/null 2>&1
rm -rf $KSROOT/scripts/ss_*  >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_shadowsocks.asp  >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_koolss.asp  >/dev/null 2>&1
rm -rf $KSROOT/bin/ss-tunnel  >/dev/null 2>&1
rm -rf $KSROOT/bin/ss-local  >/dev/null 2>&1
rm -rf $KSROOT/bin/ss-redir >/dev/null 2>&1
rm -rf $KSROOT/bin/ssr* >/dev/null 2>&1
rm -rf $KSROOT/bin/pdnsd >/dev/null 2>&1
rm -rf $KSROOT/bin/Pcap_DNSProxy >/dev/null 2>&1
rm -rf $KSROOT/bin/dnscrypt-proxy >/dev/null 2>&1
rm -rf $KSROOT/bin/dns2socks >/dev/null 2>&1
rm -rf $KSROOT/bin/chinadns >/dev/null 2>&1
rm -rf $KSROOT/bin/resolveip >/dev/null 2>&1
rm -rf $KSROOT/bin/busybox >/dev/null 2>&1
rm -rf $KSROOT/bin/ps >/dev/null 2>&1
rm -rf /usr/lib/lua/luci/controller/sadog.lua >/dev/null 2>&1
[ -f "/koolshare/webs/files/koolss.tar.gz" ] && rm -rf /koolshare/webs/files/koolss.tar.gz

# 清理一些不用的设置
sed -i '/sspcapupdate/d' /etc/crontabs/root >/dev/null 2>&1

# 复制文件
cd /tmp
echo_date 复制安装包内的文件到路由器...
cp -rf /tmp/koolss/bin/* $KSROOT/bin/
cp -rf /tmp/koolss/ss/* $KSROOT/ss/
cp -rf /tmp/koolss/scripts/* $KSROOT/scripts/
cp -rf /tmp/koolss/init.d/* $KSROOT/init.d/
cp -rf /tmp/koolss/webs/* $KSROOT/webs/
cp /tmp/koolss/install.sh $KSROOT/scripts/ss_install.sh
cp /tmp/koolss/uninstall.sh $KSROOT/scripts/uninstall_koolss.sh
[ ! -L "/koolshare/bin/ssr-tunnel" ] && ln -sf /koolshare/bin/ssr-local /koolshare/bin/ssr-tunnel
# delete luci cache
rm -rf /tmp/luci-*

# 为新安装文件赋予执行权限...
echo_date 为新安装文件赋予执行权限...
chmod 755 $KSROOT/bin/*
chmod 755 $KSROOT/ss/ssstart.sh
chmod 755 $KSROOT/scripts/ss_*
chmod 755 $KSROOT/init.d/S99koolss.sh


local_version=`cat $KSROOT/ss/version`
echo_date 设置版本号为$local_version...
dbus set ss_version=$local_version

sleep 1
echo_date 删除相关安装包...
rm -rf /tmp/koolss* >/dev/null 2>&1

echo_date 设置一些安装信息...
dbus set softcenter_module_koolss_description="轻松科学上网~"
dbus set softcenter_module_koolss_install=1
dbus set softcenter_module_koolss_name=koolss
dbus set softcenter_module_koolss_title=koolss
dbus set softcenter_module_koolss_version=$local_version

if [ "$ss_basic_enable" == "1" ];then
	echo_date 重启koolss！
	sh $KSROOT/ss/ssstart.sh restart
fi

sleep 1
echo_date SS插件安装完成...