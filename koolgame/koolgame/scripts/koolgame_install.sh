#! /bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export koolgame`

# 判断路由架构和平台
case $(uname -m) in
  armv7l)
  	echo $(date): 本插件用于koolshare lede x86_64固件平台，arm平台不能安装！！！
  	echo $(date): 退出安装！
    exit 0
    ;;
  mips)
  	echo $(date): 本插件用于koolshare lede x86_64固件平台，mips平台不能安装！！！
  	echo $(date): 退出安装！
    exit 0
    ;;
  x86_64)
  	fw867=`cat /etc/banner|grep fw867`
  	if [ -d "/koolshare" ] && [ -n "$fw867" ];then
		echo $(date): 固件平台【koolshare lede x86_64】符合安装要求，开始安装插件！
    else
		echo $(date): 本插件用于koolshare lede x86_64固件平台，其它x86_64固件平台不能安装！！！
		exit 0
    fi
    ;;
  *)
  	echo $(date): 本插件用于koolshare lede x86_64固件平台，其它平台不能安装！！！
  	echo $(date): 退出安装！
    exit 0
    ;;
esac

# 准备
echo $(date): 创建相关文件夹...
mkdir -p $KSROOT/configs
mkdir -p $KSROOT/configs/koolgame
mkdir -p $KSROOT/init.d

# 关闭koolgame
if [ "$koolgame_basic_enable" == "1" ];then
	echo $(date): 先关闭KOOLGAME，保证文件更新成功!
	sh $KSROOT/scripts/koolgame_config.sh stop
fi

#升级前先删除无关文件
echo $(date): 清可能存在的理旧文件...
rm -rf $KSROOT/init.d/S98koolgame.sh >/dev/null 2>&1
rm -rf $KSROOT/scripts/koolgame_*  >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_koolgame.asp  >/dev/null 2>&1
rm -rf $KSROOT/bin/koolgame  >/dev/null 2>&1
rm -rf $KSROOT/bin/pdu  >/dev/null 2>&1
rm -rf $KSROOT/configs/koolgame*

# 复制文件
cd /tmp
echo $(date): 复制安装包内的文件到路由器...
cp -rf /tmp/koolgame/bin/* $KSROOT/bin/
cp -rf /tmp/koolgame/scripts/* $KSROOT/scripts/
cp -rf /tmp/koolgame/init.d/* $KSROOT/init.d/
cp -rf /tmp/koolgame/webs/* $KSROOT/webs/
cp -rf /tmp/koolgame/configs/* $KSROOT/configs/
cp /tmp/koolgame/install.sh $KSROOT/scripts/koolgame_install.sh
cp /tmp/koolgame/uninstall.sh $KSROOT/scripts/uninstall_koolgame.sh

# 为新安装文件赋予执行权限...
echo $(date): 为新安装文件赋予执行权限...
chmod 755 $KSROOT/bin/*
chmod 755 $KSROOT/scripts/koolgame_*
chmod 755 $KSROOT/init.d/S98koolgame.sh
ln -sf $KSROOT/init.d/S98koolgame.sh /etc/rc.d/S98koolgame.sh

sleep 1
echo $(date): 删除相关安装包...
rm -rf /tmp/koolgame* >/dev/null 2>&1

echo $(date): 设置一些安装信息...
dbus set softcenter_module_koolgame_description="小宝开发的游戏加速V2~"
dbus set softcenter_module_koolgame_install=1
dbus set softcenter_module_koolgame_name=koolgame
dbus set softcenter_module_koolgame_title=游戏加速
dbus set softcenter_module_koolgame_version=1.0.0

if [ "$koolgame_basic_enable" == "1" ];then
	echo $(date): 重启koolgame！
	sh $KSROOT/scripts/koolgame_config.sh start
fi

sleep 1
echo $(date): KOOLGAME插件安装完成...