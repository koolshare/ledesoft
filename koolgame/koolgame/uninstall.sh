#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

confs=`dbus list koolgame | cut -d "=" -f 1 | grep -v "version"`
for conf in $confs
do
	echo_date 移除$conf >> $LOG_FILE
	dbus remove $conf
done

sleep 1

rm -rf $KSROOT/init.d/S98koolgame.sh >/dev/null 2>&1
rm -rf /etc/rc.d/S98koolgame.sh >/dev/null 2>&1
rm -rf $KSROOT/scripts/koolgame_*  >/dev/null 2>&1
rm -rf $KSROOT/scripts/uninstall_koolgame.sh  >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_koolgame.asp  >/dev/null 2>&1
rm -rf $KSROOT/webs/res/icon-koolgame*  >/dev/null 2>&1
rm -rf $KSROOT/bin/koolgame  >/dev/null 2>&1
rm -rf $KSROOT/bin/pdu  >/dev/null 2>&1
rm -rf $KSROOT/configs/koolgame*

dbus remove softcenter_module_koolgame_description
dbus remove softcenter_module_koolgame_install
dbus remove softcenter_module_koolgame_name
dbus remove softcenter_module_koolgame_title
dbus remove softcenter_module_koolgame_version
