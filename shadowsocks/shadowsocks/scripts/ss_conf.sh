#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'


remove_conf_all(){
	echo_date 尝试关闭shadowsocks...
	sh $KSROOT/ss/start.sh stop
	echo_date 开始清理shadowsocks配置...
	confs=`dbus list ss | cut -d "=" -f 1 | grep -v "version"`
	for conf in $confs
	do
		echo_date 移除$conf
		dbus remove $conf
	done
	echo_date 设置一些默认参数...
	dbus set ss_basic_enable="0"
	dbus set ss_basic_version=`cat $KSROOT/ss/version` 
	echo_date 完成！
}

remove_ss_node(){
	echo_date 开始清理shadowsocks节点配置...
	confs1=`dbus list ssconf | cut -d "=" -f 1`
	confs2=`dbus list ssrconf | cut -d "=" -f 1`
	confs3=`dbus list ssv2conf | cut -d "=" -f 1`
	for conf in $confs1 $confs2 $confs3
	do
		echo_date 移除$conf
		dbus remove $conf
	done
	echo_date 完成！
}

remove_ss_acl(){
	echo_date 开始清理shadowsocks配置...
	confs=`dbus list ss_acl | cut -d "=" -f 1`
	for conf in $confs
	do
		echo_date 移除$conf
		dbus remove $conf
	done
	echo_date 完成！
}

case $2 in
1)
	remove_conf_all > /tmp/upload/ss_log.txt
	http_response "$1"
	echo XU6J03M6 >> /tmp/upload/ss_log.txt
	;;
2)
	remove_ss_node > /tmp/upload/ss_log.txt
	http_response "$1"
	echo XU6J03M6 >> /tmp/upload/ss_log.txt
	;;
3)
	remove_ss_acl > /tmp/upload/ss_log.txt
	http_response "$1"
	echo XU6J03M6 >> /tmp/upload/ss_log.txt
	;;
4)
	echo_date "" > /tmp/upload/ss_log.txt
	dbus list ss | grep -v "status" | grep -v "enable" | grep -v "version" | grep -v "success" | sed 's/=/=\"/' | sed 's/$/\"/g'|sed 's/^/dbus set /' | sed '1 i#!/bin/sh' > $KSROOT/webs/files/ss_conf_backup.sh
	sleep 1
	http_response "$1"
	echo XU6J03M6 >> /tmp/upload/ss_log.txt
	;;
5)
	echo_date "开始恢复SS配置..." > /tmp/upload/ss_log.txt
	file_nu=`ls /tmp/upload/ss_conf_backup* wc -l`
	file_name=`ls /tmp/upload/ss_conf_backup*`
	i=10
	until [ -n "$file_nu" ]
	do
	    i=$(($i-1))
	    if [ "$i" -lt 1 ];then
	        echo_date "错误：没有找到恢复文件!"
	        exit
	    fi
	    sleep 1
	done
	format=`cat /tmp/upload/ss_conf_backup_2017_03_20_20-23-41.txt |grep dbus`
	if [ -n "format" ];then
		echo_date "检测到正确格式的配置文件！" >> /tmp/upload/ss_log.txt
		chmod +x /tmp/upload/$file_name
		echo_date "恢复中..." >> /tmp/upload/ss_log.txt
		sh $file_name
		sleep 1
		rm -rm /tmp/upload/$file_name
		dbus set ss_basic_version=`cat $KSROOT/ss/version`
		echo_date "恢复完毕！" >> /tmp/upload/ss_log.txt
	else
		echo_date "配置文件格式错误！" >> /tmp/upload/ss_log.txt
	fi
	http_response "$1"
	echo XU6J03M6 >> /tmp/upload/ss_log.txt
	;;
6)
	echo_date "开始打包..." > /tmp/upload/ss_log.txt
	echo_date "请等待一会儿...下载会自动开始." >> /tmp/upload/ss_log.txt
	mkdir -p /jffs/koolshare/webs/files
	cd $KSROOT/
	mv $KSROOT/scripts/ss_install.sh $KSROOT/install.sh
	cp $KSROOT/scripts/uninstall_shadowsocks.sh $KSROOT/uninstall.sh
	tar -czv -f /jffs/koolshare/webs/files/shadowsocks.tar.gz bin/ss-* bin/rss-* bin/pdnsd bin/Pcap_DNSProxy bin/dns2socks bin/dnscrypt-proxy bin/chinadns bin/resolveip scripts/ss_* res/icon-shadowsocks* ss/ webs/Module_shadowsocks.asp ./install.sh ./uninstall.sh >> /tmp/upload/ss_log.txt
	http_response "$1"
	echo XU6J03M6 >> /tmp/upload/ss_log.txt
	sleep 10 
	rm -rf /jffs/koolshare/webs/files/shadowsocks.tar.gz
	mv $KSROOT/install.sh $KSROOT/scripts/ss_install.sh 
	rm -rf $KSROOT/uninstall.sh
	;;
esac










