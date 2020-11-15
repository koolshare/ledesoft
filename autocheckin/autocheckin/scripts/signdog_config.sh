#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export autocheckin_`
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
LOG_FILE=/tmp/upload/qiandao_log.txt
COOKIE_DIR=/tmp/upload/COOKIE/
echo "" > $LOG_FILE

backup() {
	echo_date "开始备份COOKIE！"
	mkdir -p $KSROOT/webs/files
	
	if [ ! -f $KSROOT/autocheckin/config.json ]; then
		echo_date "：$KSROOT/autocheckin/config.json 不存在！"
		file_found=0
	fi

	if [ "$file_found" == "0" ];then
		echo_date "退出备份！"
		echo XU6J03M6
		exit 1
	fi

	cd $KSROOT/autocheckin
	tar czf /tmp/upload/signdog.tar.gz config.json .cache/
	cp /tmp/upload/signdog.tar.gz $KSROOT/webs/files/signdog.tar.gz
	echo_date "COOKIE文件备份完毕"
}

stop_autocheckin(){
	echo_date "关闭autocheckin主进程..."
	kill -9 `pidof signdog` >/dev/null 2>&1
	killall signdog >/dev/null 2>&1
}

restart_autocheckin(){
	echo_date "重启autocheckin主进程！"
	cd $KSROOT/autocheckin && ./signdog >/dev/null 2>&1 &
}

restore() {
	if [ -f /tmp/upload/signdog_config.tar.gz ];then
		echo_date "开始恢复证书！"
		mkdir -p $COOKIE_DIR
		cp /tmp/upload/signdog_config.tar.gz $COOKIE_DIR
		cd $COOKIE_DIR
		tar xzf $COOKIE_DIR/signdog_config.tar.gz
	else
		echo_date "没有找到上传的COOKIE备份文件！退出恢复！"
		echo XU6J03M6
		exit 1
	fi
	
	cp -r . $COOKIE_DIR $KSROOT/autocheckin
	rm -rf $COOKIE_DIR
	rm -f /tmp/upload/signdog_config.tar.gz
	rm -rf /tmp/upload/signdog.tar.gz
	rm -rf $KSROOT/autocheckin/signdog_config.tar.gz
	rm -rf $KSROOT/autocheckin/COOKIE
	stop_autocheckin
	sleep 1
	restart_autocheckin
	echo_date "COOKIE文件恢复成功！"
}

case $2 in
1)
	#备份cookie
	echo_date "------------------------------ 备份COOKIE文件 -------------------------------" > $LOG_FILE
	backup >> $LOG_FILE
	http_response "$1"
	sleep 10
	rm -rf $KSROOT/webs/files/signdog.tar.gz
	rm -rf /tmp/upload/signdog.tar.gz
	echo_date "------------------------------ 备份COOKIE文件 -------------------------------" >> $LOG_FILE
	echo XU6J03M6 >> $LOG_FILE
	;;
2)
	#恢复cookie
	echo_date "------------------------------ 恢复COOKIE文件 -------------------------------" > $LOG_FILE
	restore >> $LOG_FILE
	http_response "$1"
	echo_date "------------------------------ 恢复COOKIE文件 -------------------------------" >> $LOG_FILE
	echo XU6J03M6 >> $LOG_FILE
	;;
esac

