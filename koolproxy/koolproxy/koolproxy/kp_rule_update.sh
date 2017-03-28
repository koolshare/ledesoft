#! /bin/sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export koolproxy_`
SOFT_DIR=/jffs/koolshare
KP_DIR=$SOFT_DIR/koolproxy

get_rule_para(){
	echo `dbus get koolproxy_rule_list|sed 's/>/\n/g'|sed '/^$/d'|awk NR==$1{print}|cut -d "<" -f "$2"`
}

update_kp_rules(){
	mkdir -p /tmp/kpd
	rm -rf rm -rf /tmp/kpd/*
	# rule_nu=`dbus list koolproxy_rule_address_|sort -n -t "=" -k 2|cut -d "=" -f 1 | cut -d "_" -f 4`
	echo_date ================== 规则更新 =================
	echo_date
	rm -rf `ls -L $KP_DIR/data/*_*.dat` 
	rm -rf `ls -L $KP_DIR/data/*_*.txt`
	rule_nu=`dbus get koolproxy_rule_list|sed 's/>/\n/g'|sed '/^$/d'|sed '/^ /d'|wc -l`
	if [ -n "$rule_nu" ]; then
		min=1
		max=$rule_nu
		while [ $min -le $max ]
		do
			rule_load=`get_rule_para $min 1`
			rule_type=`get_rule_para $min 2`
			rule_addr=`get_rule_para $min 3`
			file_name=`echo $rule_addr|grep -Eo "\w+.dat|\w+.txt"`
			
			echo_date ① 检测$file_name 是否有更新...
			wget --no-check-certificate -q --timeout=3 --tries=2 $rule_addr -O /tmp/kpd/$min"_"$file_name
			if [ "$?" == "0" ]; then
				MD5_TMP=`md5sum /tmp/kpd/$min"_"$file_name| awk '{print $1}'`
				MD5_ORI=`md5sum $KP_DIR/rule_store/$min"_"$file_name| awk '{print $1}'`
				if [ ! -f $KP_DIR/rule_store/$min"_"$file_name ] || [ "$MD5_TMP"x != "$MD5_ORI"x ];then
					echo_date ② 更新$rule_addr
					mv -f /tmp/kpd/$min"_"$file_name $KP_DIR/rule_store/
				else
					echo_date ② 本地$file_name 已经是最新！
				fi
			else
				rm -rf rm -rf /tmp/kpd/*
				echo_date ① 检测规则错误！请检查你的网络到 $rule_addr 的连通性！
			fi
			[ "$rule_load" == "1" ] && \
			echo_date ③ 应用规则文件：$file_name && \
			ln -sf $KP_DIR/rule_store/$min"_"$file_name $KP_DIR/data/$min"_"$file_name
			echo_date 
		    min=`expr $min + 1`
		done  
	else
		echo_date ！！！没有加载任何规则！退出！！！
		dbus set koolproxy_enable=0
		exit
	fi
	echo_date ========================================
}

transform_rule(){
	sed -i '/youku/d' /tmp/dnsmasq.adblock >/dev/null 2>&1
	sed -i '/[1-9]\{1,3\}\.[1-9]\{1,3\}\.[1-9]\{1,3\}\.[1-9]\{1,3\}/d' /tmp/dnsmasq.adblock >/dev/null 2>&1
}

copy_rules(){
	mv /tmp/dnsmasq.adblock /jffs/koolshare/koolproxy/data/
	rm -rf /tmp/dnsmasq1.adblock
	dbus set koolproxy_host_nu=`cat /jffs/koolshare/koolproxy/data/dnsmasq.adblock|wc -l`
}

update_host(){
	echo_date 正在下载adblockplus规则...
	wget --no-check-certificate --timeout=2 --tries=1 -O /tmp/dnsmasq1.adblock - https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt
	cat /tmp/dnsmasq1.adblock | grep ^\|\|[^\*]*\^$ | sed -e 's:||:address\=\/:' -e 's:\^:/0\.0\.0\.0:' > /tmp/dnsmasq.adblock
	transform_rule
	if [ ! -f "/jffs/koolshare/koolproxy/data/dnsmasq.adblock" ];then
		copy_rules
	else
		if [ -L "$KSROOT/bin/diff" ];then
			diff /tmp/dnsmasq.adblock /jffs/koolshare/koolproxy/data/dnsmasq.adblock >/dev/null
			[ $? == 0 ] && echo_date adblockplus本地规则和服务器规则相同，无需更新! && exit
			echo_date 检测到adblockplus规则有更新，开始转换规则！
			copy_rules
			echo_date adblockplus规则转换完成。
		else
			echo_date 没有检测到diff，将不进行对比，直接覆盖刚才下载的规则！
			copy_rules
		fi
	fi
}

update_kp_rules
[ "$koolproxy_host" == "1" ] && update_host