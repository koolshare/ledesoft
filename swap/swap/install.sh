#! /bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export swap`


cd /tmp
cp -rf /tmp/swap/scripts/* $KSROOT/scripts/
cp -rf /tmp/swap/webs/* $KSROOT/webs/
cp -rf /tmp/swap/res/* $KSROOT/res/

cp /tmp/swap/uninstall.sh $KSROOT/scripts/uninstall_swap.sh

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/scripts/swap*

sleep 1
rm -rf /tmp/swap* >/dev/null 2>&1









