#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export cloud_torrent_`
mkdir -p /koolshare/configs

start(){
	cat > /koolshare/configs/cloud_torrent.json <<-EOF
		{
		  "AutoStart": true,
		  "DisableEncryption": false,
		  "DownloadDirectory": "$cloud_torrent_path",
		  "EnableUpload": true,
		  "EnableSeeding": false,
		  "IncomingPort": 50007
		}
		
	EOF
	sleep 1
	start-stop-daemon -S -q -b -m -p /tmp/var/cloud_torrent.pid \
	-x /koolshare/bin/cloud-torrent \
	-- -t $cloud_torrent_title1 -p $cloud_torrent_port -a $cloud_torrent_usr:$cloud_torrent_passwd \
	-c /koolshare/configs/cloud_torrent.json
		
	[ ! -L "/etc/rc.d/S77cloud_torrent.sh" ] && ln -sf /koolshare/init.d/S77cloud_torrent.sh /etc/rc.d/S77cloud_torrent.sh
}

stop(){
	killall cloud-torrent >/dev/null 2>&1
}

# used by rc.d
case $1 in
start)
	if [ "$cloud_torrent_enable" == "1" ];then
		stop
		sleep 1
		start
	else
        stop
    fi
	;;
stop)
    stop
	;;
esac

# used by httpdb
case $2 in
start)
	if [ "$cloud_torrent_enable" == "1" ];then
		stop
		sleep 1
		start
        http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'
	else
        stop
        http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'
    fi
	;;
stop)
    stop
    http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'
	;;
esac


