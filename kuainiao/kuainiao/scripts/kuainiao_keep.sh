#!/bin/sh
#2017/05/01 by kenney
#version 0.4

KSROOT="/jffs/koolshare"
source $KSROOT/scripts/base.sh
eval `dbus export kuainiao`
#source ./kuainiao_config.sh
ex_time=`date "+%Y-%m-%d %H:%M:%S"`

keepalive_up(){
	up_ret=`$kuainiao_HTTP_REQ  --header "User-Agent:android-async-http/xl-acc-sdk/version-1.0.0.1" "$kuainiao_config_upapi/keepalive?peerid=$kuainiao_config_peerid&userid=$kuainiao_config_uid&client_type=android-uplink-2.3.3.9&client_version=andrioduplink-2.3.3.9&os=android-7.0.24DUK-AL20&sessionid=$kuainiao_config_session&user_type=1&dial_account=$kuainiao_dial_upaccount"`
	errcode=`echo $up_ret|awk -F '"errno":' '{print $2}'|awk -F '[,}"]' '{print $1}'`
	if [ "$errcode" != "0" ];then
		#dbus set kuainiao_run_upid=0
		dbus set kuainiao_up_state="迅雷上行提速失效！$ex_time"
		dbus set kuainiao_run_upstatus=0
	else
		#dbus set kuainiao_run_upid=$(expr $kuainiao_run_upid + 1)
		dbus set kuainiao_up_state="您的上行带宽已从${kuainiao_old_upstream}M提升到${kuainiao_max_upstream}M  $ex_time"
		dbus set kuainiao_run_upstatus=1
	fi
}

keepalive_down(){
	_ts=`date +%s`000
	ret=`$kuainiao_HTTP_REQ "$kuainiao_config_api/keepalive?peerid=$kuainiao_config_peerid&userid=$kuainiao_config_uid&user_type=1&sessionid=$kuainiao_config_session&dial_account=$kuainiao_dial_account&client_type=android-swjsq-$kuainiao_app_version&client_version=androidswjsq-$kuainiao_app_version&os=android-5.0.1.24SmallRice&time_and=$_ts"`
	errcode=`echo $ret|awk -F '"errno":' '{print $2}'|awk -F '[,}"]' '{print $1}'`
	if [ "$errcode" != "0" ];then
		#dbus set kuainiao_run_upid=0
		dbus set kuainiao_down_state="迅雷下行提速失效！$ex_time"
		dbus set kuainiao_run_status=0
	else
		#dbus set kuainiao_run_upid=$(expr $kuainiao_run_upid + 1)
		dbus set kuainiao_down_state="您的下行带宽已从${kuainiao_old_downstream}M提升到${kuainiao_max_downstream}M $ex_time"
		dbus set kuainiao_run_status=1
	fi
}

add_kuainiao_cru(){
	cru_str=`cru l|grep kuainiao`
	if [ -z "$cru_str" ];then
		cru a kuainiao "*/4 * * * * /bin/sh $KSROOT/scripts/kuainiao_keep.sh"
	fi
}

#echo $(date "+%Y-%m-%d %H:%M:%S") >>/jffs/koolshare/kn.text
if [ "$kuainiao_enable" == "1" ]&&[ "$kuainiao_can_upgrade" == "1" ];then
	keepalive_down
	add_kuainiao_cru
	if [ `dbus get kuainiao_run_status` == 0 ];then
		/bin/sh /jffs/koolshare/scripts/kuainiao_config.sh
  	fi
fi
if [ "$kuainiao_upenable" == "1" ]&&[ "$kuainiao_can_upupgrade" == "1" ];then
	keepalive_up
	add_kuainiao_cru
	if [ `dbus get kuainiao_run_upstatus` == 0 ];then
		/bin/sh /jffs/koolshare/scripts/kuainiao_config.sh
  	fi
fi
