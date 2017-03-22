#! /bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export webshell`

killall webshell

cd /tmp
cp -rf /tmp/webshell/bin/* $KSROOT/bin/
cp -rf /tmp/webshell/scripts/* $KSROOT/scripts/
cp -rf /tmp/webshell/webs/* $KSROOT/webs/
cp -rf /tmp/webshell/res/* $KSROOT/res/

cp /tmp/webshell/uninstall.sh $KSROOT/scripts/uninstall_webshell.sh

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/bin/webshell
chmod 755 $KSROOT/scripts/webshell_*

sleep 1
rm -rf /tmp/webshell* >/dev/null 2>&1









