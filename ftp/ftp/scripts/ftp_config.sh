#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export ftp_`

config_anonymous(){
	if [ "$ftp_anonymous" == "1" ]; then
		sed -i 's/anonymous_enable=NO/anonymous_enable=YES/g' $KSROOT/ftp/ftp.conf
	else
		sed -i 's/anonymous_enable=YES/anonymous_enable=NO/g' $KSROOT/ftp/ftp.conf
	fi
}

start_ftp(){
	mkdir -p /tmp/anymous
	mkdir -m 0755 -p /var/run/vsftpd
	chown root:nogroup /tmp/anymous
	chmod 557 /tmp/anymous
	$KSROOT/ftp/ftp $KSROOT/ftp/ftp.conf
}

stop_ftp(){
	killall -q -9 ftp
}

creat_start_up(){
	[ ! -L "/etc/rc.d/S94ftp.sh" ] && ln -sf /koolshare/init.d/S94ftp.sh /etc/rc.d/S94ftp.sh
}


if [ "$ftp_enable" == "1" ]; then
	stop_ftp
	sleep 1
	config_anonymous
	start_ftp
	creat_start_up
   	http_response '服务已开启！页面将在3秒后刷新'
else
	stop_ftp
	del_start_up
	http_response '服务已关闭！页面将在3秒后刷新'
fi

