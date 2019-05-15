#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

mkdir -p $KSROOT/autocheckin
cp -rf /tmp/autocheckin/scripts/* $KSROOT/scripts/
cp -rf /tmp/autocheckin/webs/* $KSROOT/webs/
cp -rf /tmp/autocheckin/init.d/* $KSROOT/init.d/
cp -rf /tmp/autocheckin/autocheckin/* $KSROOT/autocheckin/
cp /tmp/autocheckin/uninstall.sh $KSROOT/scripts/uninstall_autocheckin.sh

chmod +x $KSROOT/scripts/autocheckin_*
chmod +x $KSROOT/autocheckin/autocheckin
chmod +x $KSROOT/init.d/S95autocheckin.sh

[ ! -L "/etc/rc.d/S95autocheckin.sh" ] && ln -sf $KSROOT/init.d/S95autocheckin.sh /etc/rc.d/S95autocheckin.sh

dbus set softcenter_module_autocheckin_description=每日批量自动签到
dbus set softcenter_module_autocheckin_install=1
dbus set softcenter_module_autocheckin_name=autocheckin
dbus set softcenter_module_autocheckin_title="签到狗2.0"
dbus set softcenter_module_autocheckin_version=0.1

sleep 1
rm -rf /tmp/autocheckin >/dev/null 2>&1
