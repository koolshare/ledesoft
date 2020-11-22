 #!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

date=`echo_date1`
signdog_pid=$(pidof signdog)
version=`$KSROOT/autocheckin/signdog -v`
pid=`pidof signdog`

if [ -n "$signdog_pid" ];then
	http_response "【$date】 签到狗 $version 进程运行正常 (PID: $pid) "
else
	http_response "<font color='#FF0000'>【警告】：签到狗还没有运行！</font>"
fi

