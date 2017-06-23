#! /bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export ddnsto`


cd /tmp
cp -rf /tmp/ddnsto/bin/* $KSROOT/bin/
cp -rf /tmp/ddnsto/scripts/* $KSROOT/scripts/
cp -rf /tmp/ddnsto/webs/* $KSROOT/webs/
cp -rf /tmp/ddnsto/res/* $KSROOT/res/
cp /tmp/ddnsto/uninstall.sh $KSROOT/scripts/uninstall_ddnsto.sh

chmod +x $KSROOT/bin/ddnsto
chmod +x $KSROOT/bin/scripts/ddnsto_*

[ ! -L "/jffs/koolshare/init.d/S88ddnsto.sh" ] && ln -sf /jffs/koolshare/scripts/ddnsto_config.sh /jffs/koolshare/init.d/S88ddnsto.sh

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/scripts/ddnsto*

dbus set softcenter_module_ddnsto_description=宝宝穿透
dbus set softcenter_module_ddnsto_install=1
dbus set softcenter_module_ddnsto_name=ddnsto
dbus set softcenter_module_ddnsto_title=ddnsto
dbus set softcenter_module_ddnsto_version=1.0.0


sleep 1
rm -rf /tmp/ddnsto* >/dev/null 2>&1










