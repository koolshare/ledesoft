#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export ftp`

mkdir -p $KSROOT/init.d
mkdir -p /tmp/upload
mkdir -p $KSROOT/ftp

cd /tmp
cp -rf /tmp/ftp/ftp/* $KSROOT/ftp/
cp -rf /tmp/ftp/scripts/* $KSROOT/scripts/
cp -rf /tmp/ftp/init.d/* $KSROOT/init.d/
cp -rf /tmp/ftp/webs/* $KSROOT/webs/
cp /tmp/ftp/uninstall.sh $KSROOT/scripts/uninstall_ftp.sh

chmod +x $KSROOT/ftp/ftp
chmod +x $KSROOT/scripts/ftp_*
chmod +x $KSROOT/init.d/S94ftp.sh

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/scripts/ftp*

dbus set softcenter_module_ftp_description=小巧安全的FTP服务器
dbus set softcenter_module_ftp_install=1
dbus set softcenter_module_ftp_name=ftp
dbus set softcenter_module_ftp_title=FTP服务器
dbus set softcenter_module_ftp_version=1.0.0

sleep 1
rm -rf /tmp/ftp* >/dev/null 2>&1










