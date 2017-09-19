#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
eval `dbus export ss`
LOG_FILE=/tmp/upload/ss_log.txt

addnum=0
updatenum=0
delnum=0
	
remove_conf_all(){
	echo_date 尝试关闭shadowsocks...
	sh $KSROOT/ss/ssstart.sh stop
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

# ===============================used in case 7 for ssr subscribe=======================================
decode_url_link(){
	link=$1
	num=$2
	len=$((${#link}-$num))
	mod4=$(($len%4))
	if [ "$mod4" -gt 0 ]; then
		var="===="
		newlink=${link}${var:$mod4}
		echo -n "$newlink" | sed 's/-/+/g; s/_/\//g' | /usr/bin/base64 -d -i 2> /dev/null
	else
		echo -n "$link" | sed 's/-/+/g; s/_/\//g' | /usr/bin/base64 -d -i 2> /dev/null
	fi
}

get_remote_config(){
	decode_link=$1
	server=$(echo "$decode_link" |awk -F':' '{print $1}')
	server_port=$(echo "$decode_link" |awk -F':' '{print $2}')
	protocol=$(echo "$decode_link" |awk -F':' '{print $3}')
	encrypt_method=$(echo "$decode_link" |awk -F':' '{print $4}')
	obfs=$(echo "$decode_link" |awk -F':' '{print $5}'|sed 's/_compatible//g')
	password=$(decode_url_link $(echo "$decode_link" |awk -F':' '{print $6}'|awk -F'/' '{print $1}') 0)
	
	if [ "$(echo "$decode_link" |grep -c "obfsparam=")" -eq 1 ]; then
		obfsparm_temp=$(echo "$decode_link" |awk -F':' '{print $6}'|awk -F'&' '{print $1}'|awk -F'=' '{print $2}')
		if [ -n "$obfsparm_temp" ]; then
			obfsparam=$(decode_url_link $obfsparm_temp 0)
		else
			obfsparam=''
		fi
		if [ "$(echo "$decode_link" | grep -c protoparam)" -eq 1 ]; then
			remarks_temp=$(echo "$decode_link" |awk -F':' '{print $6}'|awk -F'&' '{print $3}'|awk -F'=' '{print $2}')
			[ -n "$remarks_temp" ] && remarks=$(decode_url_link $remarks_temp 0) || remarks=koolshare
			group_temp=$(echo "$decode_link" |awk -F':' '{print $6}'|awk -F'&' '{print $4}'|awk -F'=' '{print $2}')
			group=$(decode_url_link $group_temp 0)
		else	
			remarks_temp=$(echo "$decode_link" |awk -F':' '{print $6}'|awk -F'&' '{print $2}'|awk -F'=' '{print $2}')
			remarks=$(decode_url_link $remarks_temp 0)
			group_temp=$(echo "$decode_link" |awk -F':' '{print $6}'|awk -F'&' '{print $3}'|awk -F'=' '{print $2}')
			group=$(decode_url_link $group_temp 0)			
		fi
	else
		obfsparam=''
		if [ "$(echo "$decode_link" | grep -c protoparam)" -eq 1 ]; then
			remarks_temp=$(echo "$decode_link" |awk -F':' '{print $6}'|awk -F'&' '{print $2}'|awk -F'=' '{print $2}')
			[ -n "$remarks_temp" ] && remarks=$(decode_url_link $remarks_temp 0) || remarks=koolshare
			group_temp=$(echo "$decode_link" |awk -F':' '{print $6}'|awk -F'&' '{print $3}'|awk -F'=' '{print $2}')
			group=$(decode_url_link $group_temp 0)
		else	
			remarks_temp=$(echo "$decode_link" |awk -F':' '{print $6}'|awk -F'&' '{print $1}'|awk -F'=' '{print $2}')
			[ -n "$remarks_temp" ] && remarks=$(decode_url_link $remarks_temp 0) || remarks=koolshare
			group_temp=$(echo "$decode_link" |awk -F':' '{print $6}'|awk -F'&' '{print $2}'|awk -F'=' '{print $2}')
			group=$(decode_url_link $group_temp 0)
		fi
	fi
	[ -n "$group" ] && group_md5=`echo $group | md5sum | sed 's/ -//g'`
	[ -n "$server" ] && server_md5=`echo $server | md5sum | sed 's/ -//g'`
	
	##把全部服务器节点写入文件 /usr/share/shadowsocks/serverconfig/all_onlineservers
	echo $server_md5 $group_md5 >> /tmp/all_onlineservers
}

update_config(){
	#isadded_server=$(uci show shadowsocks | grep -c "server=\'$server\'")
	isadded_server=$(cat /tmp/all_localservers | grep $group_md5 | awk '{print $1}' | grep -c $server_md5)
	if [ "$isadded_server" -eq 0 ]; then
		# 如果在本地的订阅节点中没有找到该节点，则是新节点，需要添加
		ssindex=$(($(dbus get ssrconf_basic_node_max)+1))
		#echo add $ssindex >> $LOG_FILE
		echo_date 添加SSR节点：$remarks >> $LOG_FILE
		dbus set ssrconf_basic_name_$ssindex=$remarks
		dbus set ssrconf_basic_mode_$ssindex=$ssr_subscribe_mode
		dbus set ssrconf_basic_server_$ssindex=$server
		dbus set ssrconf_basic_port_$ssindex=$server_port
		dbus set ssrconf_basic_rss_protocal_$ssindex=$protocol
		dbus set ssrconf_basic_method_$ssindex=$encrypt_method
		dbus set ssrconf_basic_rss_obfs_$ssindex=$obfs
		dbus set ssrconf_basic_password_$ssindex=$password
		dbus set ssrconf_basic_group_$ssindex=$group
		dbus set ssrconf_basic_node_max=$ssindex
		[ "$ssr_subscribe_obfspara" == "0" ] && dbus set ssrconf_basic_rss_obfs_para_$ssindex=""
		[ "$ssr_subscribe_obfspara" == "1" ] && dbus set ssrconf_basic_rss_obfs_para_$ssindex=$obfsparam
		[ "$ssr_subscribe_obfspara" == "2" ] && dbus set ssrconf_basic_rss_obfs_para_$ssindex=$ssr_subscribe_obfspara_val
		let addnum+=1
	else
		# 如果在本地的订阅节点中没找到该节点，检测下配置是否更改，如果更改，则更新配置
		index=$(cat /tmp/all_localservers| grep $group_md5 | grep $server_md5 |awk '{print $3}')
		local_server_port=$(dbus get ssrconf_basic_port_$index)
		local_protocol=$(dbus get ssrconf_basic_rss_protocal_$index)
		local_encrypt_method=$(dbus get ssrconf_basic_method_$index)
		local_obfs=$(dbus get ssrconf_basic_rss_obfs_$index)
		local_password=$(dbus get ssrconf_basic_password_$index)
		local_remarks=$(dbus get ssrconf_basic_name_$index)
		local_group=$(dbus get ssrconf_basic_group_$index)
		#echo update $index >> $LOG_FILE
		local i=0
		[ "$ssr_subscribe_obfspara" == "0" ] && dbus set ssrconf_basic_rss_obfs_para_$index=""
		[ "$ssr_subscribe_obfspara" == "1" ] && dbus set ssrconf_basic_rss_obfs_para_$index=$obfsparam
		[ "$ssr_subscribe_obfspara" == "2" ] && dbus set ssrconf_basic_rss_obfs_para_$index=$ssr_subscribe_obfspara_val
		dbus set ssrconf_basic_mode_$index=$ssr_subscribe_mode
		[ "$local_remarks" != "$remarks" ] dbus set ssrconf_basic_name_$index=$remarks
		[ "$local_server_port" != "$server_port" ] && dbus set ssrconf_basic_port_$index=$server_port && let i+=1
		[ "$local_protocol" != "$protocol" ] && dbus set ssrconf_basic_rss_protocal_$index=$protocol && let i+=1
		[ "$local_encrypt_method" != "$encrypt_method" ] && dbus set ssrconf_basic_method_$index=$encrypt_method && let i+=1
		[ "$local_obfs" != "$obfs" ] && dbus set ssrconf_basic_rss_obfs_$index=$obfs && let i+=1
		[ "$local_password" != "$password" ] && dbus set ssrconf_basic_password_$index=$password && let i+=1
		[ "$i" -gt 0 ] && echo_date 修改SSR节点：$remarks >> $LOG_FILE && let updatenum+=1
	fi
}

del_none_exist(){
	#删除订阅服务器已经不存在的节点
	for localserver in $(cat /tmp/all_localservers| grep $group_md5|awk '{print $1}')
	do
		if [ "`cat /tmp/all_onlineservers | grep -c $localserver`" -eq "0" ];then
			del_index=`cat /tmp/all_localservers | grep $localserver | awk '{print $3}'`
			#for localindex in $(dbus list ssrconf_basic_server|grep -v ssrconf_basic_server_ip_|grep -w $localserver|cut -d "_" -f 4 |cut -d "=" -f1)
			for localindex in $del_index
			do
				echo_date 删除节点：`dbus get ssrconf_basic_name_$localindex` ，因为该节点在订阅服务器上已经不存在... >> $LOG_FILE
				dbus remove ssrconf_basic_group_$localindex
				dbus remove ssrconf_basic_method_$localindex
				dbus remove ssrconf_basic_mode_$localindex
				dbus remove ssrconf_basic_name_$localindex
				dbus remove ssrconf_basic_password_$localindex
				dbus remove ssrconf_basic_port_$localindex
				dbus remove ssrconf_basic_rss_obfs_$localindex
				dbus remove ssrconf_basic_rss_obfs_para_$localindex
				dbus remove ssrconf_basic_rss_protocal_$localindex
				dbus remove ssrconf_basic_server_$localindex
				let delnum+=1
			done
		fi
	done
}

# 发生在订阅节点过程中，如果之前已经订阅过，再次订阅，如果订阅服务器上已经删除的节点在本地还存在
# 则需要将此部分节点删除，如果删除的节点在中间部分，会导致节点顺序不一致，使web出现错误
# 此时需要重写顺序
# 调整顺序的判断为，节点号和序号不一致需要调整，调整时，将对应节点号（nu）的值储存到对应序号（i）的值中，并删除应节点号（nu）对应的值，保证不会超出范围
remove_node_gap(){
	SEQ=$(dbus list ssrconf_basic_port|cut -d "_" -f 4|cut -d "=" -f 1|sort -n)
	MAX=$(dbus list ssrconf_basic_port|cut -d "_" -f 4|cut -d "=" -f 1|sort -rn|head -n1)
	NODE_NU=$(dbus list ssrconf_basic_port|wc -l)
	KCP_NODE=`dbus get ss_kcp_node`
	
	echo_date 现有节点顺序：$SEQ >> $LOG_FILE
	echo_date 最大SSR节点序号：$MAX >> $LOG_FILE
	echo_date SSR节点数量：$NODE_NU >> $LOG_FILE
	
	if [ "$MAX" != "$NODE_NU" ];then
		echo_date 节点排序需要调整! >> $LOG_FILE
		y=1
		for nu in $SEQ
		do
			if [ "$y" == "$nu" ];then
				echo_date 节点 $y 不需要调整 ! >> $LOG_FILE
			else
				echo_date 调整节点 $y ! >> $LOG_FILE
				[ -n "$(dbus get ssrconf_basic_group_$nu)" ] && dbus set ssrconf_basic_group_"$y"="$(dbus get ssrconf_basic_group_$nu)" && dbus remove ssrconf_basic_group_$nu
				[ -n "$(dbus get ssrconf_basic_method_$nu)" ] && dbus set ssrconf_basic_method_"$y"="$(dbus get ssrconf_basic_method_$nu)" && dbus remove ssrconf_basic_method_$nu
				[ -n "$(dbus get ssrconf_basic_mode_$nu)" ] && dbus set ssrconf_basic_mode_"$y"="$(dbus get ssrconf_basic_mode_$nu)" && dbus remove ssrconf_basic_mode_$nu
				[ -n "$(dbus get ssrconf_basic_name_$nu)" ] && dbus set ssrconf_basic_name_"$y"="$(dbus get ssrconf_basic_name_$nu)" && dbus remove ssrconf_basic_name_$nu
				[ -n "$(dbus get ssrconf_basic_password_$nu)" ] && dbus set ssrconf_basic_password_"$y"="$(dbus get ssrconf_basic_password_$nu)" && dbus remove ssrconf_basic_password_$nu
				[ -n "$(dbus get ssrconf_basic_port_$nu)" ] && dbus set ssrconf_basic_port_"$y"="$(dbus get ssrconf_basic_port_$nu)" && dbus remove ssrconf_basic_port_$nu
				[ -n "$(dbus get ssrconf_basic_rss_obfs_$nu)" ] && dbus set ssrconf_basic_rss_obfs_"$y"="$(dbus get ssrconf_basic_rss_obfs_$nu)" && dbus remove ssrconf_basic_rss_obfs_$nu
				[ -n "$(dbus get ssrconf_basic_rss_obfs_para_$nu)" ] && dbus set ssrconf_basic_rss_obfs_para_"$y"="$(dbus get ssrconf_basic_rss_obfs_para_$nu)" && dbus remove ssrconf_basic_rss_obfs_para_$nu
				[ -n "$(dbus get ssrconf_basic_rss_protocal_$nu)" ] && dbus set ssrconf_basic_rss_protocal_"$y"="$(dbus get ssrconf_basic_rss_protocal_$nu)" && dbus remove ssrconf_basic_rss_protocal_$nu
				[ -n "$(dbus get ssrconf_basic_rss_protocal_para_$nu)" ] && dbus set ssrconf_basic_rss_protocal_para_"$y"="$(dbus get ssrconf_basic_rss_protocal_para_$nu)" && dbus remove ssrconf_basic_rss_protocal_para_$nu
				[ -n "$(dbus get ssrconf_basic_server_$nu)" ] && dbus set ssrconf_basic_server_"$y"="$(dbus get ssrconf_basic_server_$nu)" && dbus remove ssrconf_basic_server_$nu
				[ -n "$(dbus get ssrconf_basic_server_ip_$nu)" ] && dbus set ssrconf_basic_server_ip_"$y"="$(dbus get ssrconf_basic_server_ip_$nu)" && dbus remove ssrconf_basic_server_ip_$nu
				[ -n "$(dbus get ssrconf_basic_lb_enable_$nu)" ] && dbus set ssrconf_basic_lb_enable_"$y"="$(dbus get ssrconf_basic_lb_enable_$nu)" && dbus remove ssrconf_basic_lb_enable_$nu
				[ -n "$(dbus get ssrconf_basic_lb_policy_$nu)" ] && dbus set ssrconf_basic_lb_policy_"$y"="$(dbus get ssrconf_basic_lb_policy_$nu)" && dbus remove ssrconf_basic_lb_policy_$nu
				[ -n "$(dbus get ssrconf_basic_lb_weight_$nu)" ] && dbus set ssrconf_basic_lb_weight_"$y"="$(dbus get ssrconf_basic_lb_weight_$nu)" && dbus remove ssrconf_basic_lb_weight_$nu

				# change kcpnode nu
				if [ "$nu" == "$KCP_NODE"];then
					dbus set ss_kcp_node="$y"
				fi
			fi
			let y+=1
		done
	else
		echo_date 节点排序正确! >> $LOG_FILE
	fi
	dbus set ssrconf_basic_node_max=$NODE_NU
	dbus set ssrconf_basic_max_node=$NODE_NU
}

# ===============================used in case 9 for re-arrange ssr node=======================================
get_dbus_value(){
	key=$1
	echo `cat /tmp/ssr_nodes.txt|grep $1=|cut -d "=" -f2`
}

# 在界面点击保存节点时运行
# 人工添加的节点在界面里开始呈现在最后一排（人工 - 订阅 - 人工），需要将其挪动到人工节点后
# 以便于对group信息的操作
rearrange_node_order(){
	local ALL_NODES=$(dbus list ssrconf_basic_port|cut -d "_" -f 4|cut -d "=" -f 1|sort -n|sed ':a;N;$!ba;s#\n# #g')
	local GP_NODES=$(dbus list ssrconf_basic_group|cut -d "_" -f 4|cut -d "=" -f 1|sort -n|sed ':a;N;$!ba;s#\n# #g')
	echo_date 所有SSR节点： $ALL_NODES
	echo_date 订阅SSR节点： $GP_NODES
	
	rm -rf /tmp/tmp_all_local_node
	if [ -n "$ALL_NODES" ] && [ -n "$GP_NODES" ];then
		for all_node in $ALL_NODES
		do
			EXIST=`echo "$GP_NODES"|grep -w $all_node`
			if [ -z "$EXIST" ];then
				echo $all_node >> /tmp/tmp_all_local_node
			fi
		done
		local LC_NODES=`cat /tmp/tmp_all_local_node | sed ':a;N;$!ba;s#\n# #g'`
	elif [ -n "$ALL_NODES" ] && [ -z "$GP_NODES" ];then
		local LC_NODES="$ALL_NODES"
	else
		local LC_NODES=""
	fi
	echo_date 人工SSR节点： $LC_NODES

	# store ssr nodes to file
	dbus list ssrconf_basic_ > /tmp/ssr_nodes.txt
	
	i=1
	if [ -n "$LC_NODES" ] || [ -n "$GP_NODES" ];then
		for nu in $LC_NODES $GP_NODES
		do
			if [ "$i" == "$nu" ];then
				echo_date 节点 $nu 不需要调整 !
			else
				echo_date 调整节点 $nu 顺序为 $i !
				[ -n "$(get_dbus_value ssrconf_basic_group_$nu)" ] && dbus set ssrconf_basic_group_"$i"="$(get_dbus_value ssrconf_basic_group_$nu)" || dbus remove ssrconf_basic_group_"$i"
				[ -n "$(get_dbus_value ssrconf_basic_method_$nu)" ] && dbus set ssrconf_basic_method_"$i"="$(get_dbus_value ssrconf_basic_method_$nu)" || dbus remove ssrconf_basic_method_"$i"
				[ -n "$(get_dbus_value ssrconf_basic_mode_$nu)" ] && dbus set ssrconf_basic_mode_"$i"="$(get_dbus_value ssrconf_basic_mode_$nu)" || dbus remove ssrconf_basic_mode_"$i"
				[ -n "$(get_dbus_value ssrconf_basic_name_$nu)" ] && dbus set ssrconf_basic_name_"$i"="$(get_dbus_value ssrconf_basic_name_$nu)" || dbus remove ssrconf_basic_name_"$i"
				[ -n "$(get_dbus_value ssrconf_basic_password_$nu)" ] && dbus set ssrconf_basic_password_"$i"="$(get_dbus_value ssrconf_basic_password_$nu)" || dbus remove ssrconf_basic_password_"$i"
				[ -n "$(get_dbus_value ssrconf_basic_port_$nu)" ] && dbus set ssrconf_basic_port_"$i"="$(get_dbus_value ssrconf_basic_port_$nu)" || dbus remove ssrconf_basic_port_"$i"
				[ -n "$(get_dbus_value ssrconf_basic_rss_obfs_$nu)" ] && dbus set ssrconf_basic_rss_obfs_"$i"="$(get_dbus_value ssrconf_basic_rss_obfs_$nu)" || dbus remove ssrconf_basic_rss_obfs_"$i"
				[ -n "$(get_dbus_value ssrconf_basic_rss_obfs_para_$nu)" ] && dbus set ssrconf_basic_rss_obfs_para_"$i"="$(get_dbus_value ssrconf_basic_rss_obfs_para_$nu)" || dbus remove ssrconf_basic_rss_obfs_para_"$i"
				[ -n "$(get_dbus_value ssrconf_basic_rss_protocal_$nu)" ] && dbus set ssrconf_basic_rss_protocal_"$i"="$(get_dbus_value ssrconf_basic_rss_protocal_$nu)" || dbus remove ssrconf_basic_rss_protocal_"$i"
				[ -n "$(get_dbus_value ssrconf_basic_rss_protocal_para_$nu)" ] && dbus set ssrconf_basic_rss_protocal_para_"$i"="$(get_dbus_value ssrconf_basic_rss_protocal_para_$nu)" || dbus remove ssrconf_basic_rss_protocal_para_"$i"
				[ -n "$(get_dbus_value ssrconf_basic_server_$nu)" ] && dbus set ssrconf_basic_server_"$i"="$(get_dbus_value ssrconf_basic_server_$nu)" || dbus remove ssrconf_basic_server_"$i"
				[ -n "$(get_dbus_value ssrconf_basic_server_ip_$nu)" ] && dbus set ssrconf_basic_server_ip_"$i"="$(get_dbus_value ssrconf_basic_server_ip_$nu)" || dbus remove ssrconf_basic_server_ip_"$i"
				[ -n "$(get_dbus_value ssrconf_basic_lb_enable_$nu)" ] && dbus set ssrconf_basic_lb_enable_"$i"="$(get_dbus_value ssrconf_basic_lb_enable_$nu)" || dbus remove ssrconf_basic_lb_enable_"$i"
				[ -n "$(get_dbus_value ssrconf_basic_lb_policy_$nu)" ] && dbus set ssrconf_basic_lb_policy_"$i"="$(get_dbus_value ssrconf_basic_lb_policy_$nu)" || dbus remove ssrconf_basic_lb_policy_"$i"
				[ -n "$(get_dbus_value ssrconf_basic_lb_weight_$nu)" ] && dbus set ssrconf_basic_lb_weight_"$i"="$(get_dbus_value ssrconf_basic_lb_weight_$nu)" || dbus remove ssrconf_basic_lb_weight_"$i"
			fi
			let i++
		done
	fi

	rm -rf /tmp/ssr_nodes.txt
}
#=================================================================================================

case $2 in
1)
	#移除所有ss配置文件
	remove_conf_all > $LOG_FILE
	http_response "$1"
	echo XU6J03M6 >> $LOG_FILE
	;;
2)
	#移除所有ss节点配置文件
	remove_ss_node > $LOG_FILE
	http_response "$1"
	echo XU6J03M6 >> $LOG_FILE
	;;
3)
	#移除所有ss访问控制配置文件
	remove_ss_acl > $LOG_FILE
	http_response "$1"
	echo XU6J03M6 >> $LOG_FILE
	;;
4)
	#备份ss配置
	echo "" > $LOG_FILE
	mkdir -p $KSROOT/webs/files
	dbus list ss | grep -v "status" | grep -v "enable" | grep -v "version" | grep -v "success" | sed 's/=/=\"/' | sed 's/$/\"/g'|sed 's/^/dbus set /' | sed '1 i\\n' | sed '1 isource /koolshare/scripts/base.sh' |sed '1 i#!/bin/sh' > $KSROOT/webs/files/ss_conf_backup.sh
	http_response "$1"
	echo XU6J03M6 >> $LOG_FILE
	sleep 10 
	rm -rf /koolshare/webs/files/ss_conf_backup.sh
	;;
5)
	#用备份的ss_conf_backup.sh 去恢复配置
	echo_date "开始恢复SS配置..." > $LOG_FILE
	file_nu=`ls /tmp/upload/ss_conf_backup | wc -l`
	x=10
	until [ -n "$file_nu" ]
	do
	    i=$(($x-1))
	    if [ "$x" -lt 1 ];then
	        echo_date "错误：没有找到恢复文件!"
	        exit
	    fi
	    sleep 1
	done
	format=`cat /tmp/upload/ss_conf_backup.sh |grep dbus`
	if [ -n "format" ];then
		echo_date "检测到正确格式的配置文件！" >> $LOG_FILE
		cd /tmp/upload
		chmod +x ss_conf_backup.sh
		echo_date "恢复中..." >> $LOG_FILE
		sh ss_conf_backup.sh
		sleep 1
		rm -rf /tmp/upload/ss_conf_backup.sh
		dbus set ss_basic_version=`cat $KSROOT/ss/version`
		echo_date "恢复完毕！" >> $LOG_FILE
	else
		echo_date "配置文件格式错误！" >> $LOG_FILE
	fi
	http_response "$1"
	echo XU6J03M6 >> $LOG_FILE
	;;
6)
	#打包ss插件
	rm -rf /tmp/shadowsocks*
	rm -rf /koolshare/webs/files/shadowsocks*
	echo_date "开始打包..." > $LOG_FILE
	echo_date "请等待一会儿...下载会自动开始." >> $LOG_FILE
	mkdir -p /koolshare/webs/files
	cd /tmp
	mkdir shadowsocks
	mkdir shadowsocks/bin
	mkdir shadowsocks/scripts
	mkdir shadowsocks/init.d
	mkdir shadowsocks/webs
	mkdir shadowsocks/webs/res
	TARGET_FOLDER=/tmp/shadowsocks
	cp $KSROOT/scripts/ss_install.sh $TARGET_FOLDER/install.sh
	cp $KSROOT/scripts/uninstall_shadowsocks.sh $TARGET_FOLDER/uninstall.sh
	cp $KSROOT/bin/ss-* $TARGET_FOLDER/bin/
	cp $KSROOT/bin/obfs-local $TARGET_FOLDER/bin/
	cp $KSROOT/bin/ssr-* $TARGET_FOLDER/bin/
	cp $KSROOT/bin/pdnsd $TARGET_FOLDER/bin/
	cp $KSROOT/bin/Pcap_DNSProxy $TARGET_FOLDER/bin/
	cp $KSROOT/bin/dns2socks $TARGET_FOLDER/bin/
	cp $KSROOT/bin/dnscrypt-proxy $TARGET_FOLDER/bin/
	cp $KSROOT/bin/chinadns $TARGET_FOLDER/bin/
	cp $KSROOT/bin/resolveip $TARGET_FOLDER/bin/
	cp $KSROOT/bin/haproxy $TARGET_FOLDER/bin/
	cp $KSROOT/bin/kcpclient $TARGET_FOLDER/bin/
	cp $KSROOT/scripts/ss_* $TARGET_FOLDER/scripts/
	cp $KSROOT/init.d/S99shadowsocks.sh $TARGET_FOLDER/init.d
	cp $KSROOT/webs/Module_shadowsocks.asp $TARGET_FOLDER/webs/
	cp $KSROOT/webs/res/icon-shadowsocks* $TARGET_FOLDER/webs/res/
	cp -r $KSROOT/ss $TARGET_FOLDER/
	rm -rf $TARGET_FOLDER/ss/*.json

	tar -czv -f /koolshare/webs/files/shadowsocks.tar.gz shadowsocks/
	rm -rf $TARGET_FOLDER
	echo_date "打包完毕！该包可以在LEDE软件中心离线安装哦~" >> $LOG_FILE
	http_response "$1"
	echo XU6J03M6 >> $LOG_FILE
	sleep 4
	rm -rf /koolshare/webs/files/shadowsocks*
	;;
7)
	# ss订阅
	echo_date "=============================================================================================" > $LOG_FILE
    echo_date "                                                       服务器订阅程序(Shell by stones & sadog)" >> $LOG_FILE
    echo_date "=============================================================================================" >> $LOG_FILE
	echo_date "开始更新在线订阅列表..." >> $LOG_FILE 
	echo_date "开始下载订阅链接到本地临时文件，请稍等..." >> $LOG_FILE
	rm -rf /tmp/ssr_subscribe_file* >/dev/null 2>&1
	curl --connect-timeout 8 -q $ssr_subscribe_link > /tmp/ssr_subscribe_file.txt
	#wget --tries=2 --timeout=8 $ssr_subscribe_link > /tmp/ssr_subscribe_file.txt
	if [ "$?" == "0" ];then
		echo_date 下载订阅成功... >> $LOG_FILE
		echo_date 开始解析节点信息... >> $LOG_FILE
		cat /tmp/ssr_subscribe_file.txt | base64_decode > /tmp/ssr_subscribe_file_temp1.txt
		# 检测ss ssr
		NODE_FORMAT=`cat /tmp/ssr_subscribe_file_temp1.txt | grep -E "^ss://"`
		NODE_NU=`cat /tmp/ssr_subscribe_file_temp1.txt | wc -l`
		LOCAL_NU=`dbus list ssrconf_basic_group|wc -l`
		if [ -n "$NODE_FORMAT" ];then
			echo_date 暂时不支持ss节点订阅... >> $LOG_FILE
			echo_date 退出订阅程序... >> $LOG_FILE
		else
			echo_date 检测到ssr节点格式，共计$NODE_NU个节点... >> $LOG_FILE
			
			rm -rf /tmp/all_localservers >/dev/null 2>&1
			rm -rf /tmp/all_onlineservers >/dev/null 2>&1
			# 收集本地节点名到文件
			LOCAL_NODES=`dbus list ssrconf_basic_group|cut -d "_" -f 4|cut -d "=" -f 1`
			if [ -n "$LOCAL_NODES" ];then
				for LOCAL_NODE in $LOCAL_NODES
				do
					#echo `dbus list ssrconf_basic_server_$LOCAL_NODE` `dbus list ssrconf_basic_group_$LOCAL_NODE`>> /tmp/all_localservers
					echo `dbus get ssrconf_basic_server_$LOCAL_NODE|md5sum|sed 's/ -//g'` `dbus get ssrconf_basic_group_$LOCAL_NODE|md5sum|sed 's/ -//g'`| eval echo `sed 's/$/ $LOCAL_NODE/g'` >> /tmp/all_localservers
				done
			else
				touch /tmp/all_localservers
			fi
			#判断格式
			maxnum=$(cat /tmp/ssr_subscribe_file.txt | base64 -d | grep "MAX=" |awk -F"=" '{print $2}')
			if [ -n "$maxnum" ]; then
				urllinks=$(cat /tmp/ssr_subscribe_file.txt | base64 -d | sed '/MAX=/d' | shuf -n${maxnum} | sed 's/ssr:\/\///g')
			else
				urllinks=$(cat /tmp/ssr_subscribe_file.txt | base64 -d | sed 's/ssr:\/\///g')
			fi
			[ -z "$urllinks" ] && continue
			for link in $urllinks
			do
				decode_link=$(decode_url_link $link 1)
				get_remote_config $decode_link
				update_config
			done
			# 去除订阅服务器上已经删除的节点
			del_none_exist
			# 节点重新排序
			remove_node_gap

			







			
		fi
		sleep 1

		USER_ADD=$(($(dbus list ssrconf_basic_server|grep -v ssrconf_basic_server_ip_|wc -l) - $(dbus list ssrconf_basic_group|wc -l))) || 0
		ONLINE_GET=$(dbus list ssrconf_basic_group|wc -l) || 0
		echo_date "本次更新，订阅来源 【$group】， 新增服务器节点 $addnum 个，修改 $updatenum 个，删除 $delnum 个；" >> $LOG_FILE
		echo_date "现共有自添加SSR节点：$USER_ADD 个。" >> $LOG_FILE
		echo_date "现共有订阅SSR节点：$ONLINE_GET 个。" >> $LOG_FILE
		echo_date "在线订阅列表更新完成!" >> $LOG_FILE
		echo_date "请等待3秒，本页面将自动刷新！" >> $LOG_FILE
		echo_date "=============================================================================================" >> $LOG_FILE
		sleep 3
		http_response "$1"
		echo XU6J03M6 >> $LOG_FILE
	else
		echo_date 下载订阅失败...请检查你的网络... >> $LOG_FILE
		rm -rf /tmp/ssr_subscribe_file.txt >/dev/null 2>&1 &
		sleep 2
		echo_date 退出订阅程序... >> $LOG_FILE
		http_response "$1"
		echo XU6J03M6 >> $LOG_FILE
	fi
	;;
8)
	sleep 1
	http_response "$1"
	;;
9)
	http_response "$1"
	;;
esac