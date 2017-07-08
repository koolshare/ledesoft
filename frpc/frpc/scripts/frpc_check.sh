#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export frpc_`

conf_file="$KSROOT/frpc/frpc.ini"
version=`$KSROOT/frpc/frpc --version`
dbus set frpc_version=$version

while true;do
	if [ $frpc_enable == 1 ];then
        if [ "`ps|grep frpc|grep -v grep|grep -v /bin/sh|wc -l`" == "0" ];then
            /bin/sh $KSROOT/scripts/frpc_config.sh >>/dev/null
        fi
    else
        break
    fi
    sleep 5
done
