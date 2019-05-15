#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export aria2`

creat_conf(){
cat > /tmp/aria2.conf <<EOF
`dbus list aria2 | grep -vw aria2_enable | grep -vw aria2_dir_str | grep -vw aria2_enable_dht | grep -vw aria2_title | grep -vw aria2_rpc_secret | grep -vw aria2_check | grep -vw aria2_check_time | grep -vw aria2_sleep | grep -vw aria2_update_enable| grep -vw aria2_update_sel | grep -vw aria2_version | grep -vw aria2_cpulimit_enable | grep -vw aria2_cpulimit_value| grep -vw aria2_version_web | grep -vw aria2_warning | grep -vw aria2_custom | grep -vw aria2_install_status|grep -vw aria2_restart |grep -vw aria2_dir| sed 's/aria2_//g' | sed 's/_/-/g'`
`dbus list aria2|grep -w aria2_dir|sed 's/aria2_//g'`
EOF
[ "$aria2_rpc_enable" == "1" ] && echo "rpc-secret=$aria2_rpc_secret" >> /tmp/aria2.conf
if [ "$aria2_enable_dht" == "1" ];then
	echo "enable-dht=true" >> /tmp/aria2.conf
else
	echo "enable-dht=false" >> /tmp/aria2.conf
fi
cat >> /tmp/aria2.conf <<EOF
`dbus list aria2|grep -w aria2_custom|sed 's/aria2_custom=//g'|sed 's/,/\n/g'`
EOF
}

start_aria2(){
	/koolshare/aria2/aria2c --conf-path=/tmp/aria2.conf -D >/dev/null 2>&1 &
}

kill_aria2(){
    killall aria2c >/dev/null 2>&1
}

update_tracker(){
  list=`wget -qO- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt|awk NF|sed ":a;N;s/\n/,/g;ta"`
  if [ -z "`grep "bt-tracker" /tmp/aria2.conf`" ]; then
      sed -i '$a bt-tracker='${list} /tmp/aria2.conf
  else
    sed -i "s@bt-tracker.*@bt-tracker=$list@g" /tmp/aria2.conf
  fi
}

open_port(){
	echo open firewall port $aria2_rpc_listen_port and 8088
	iptables -I INPUT -p tcp --dport $aria2_rpc_listen_port -j ACCEPT >/dev/null 2>&1
	iptables -I INPUT -p tcp --dport 8088 -j ACCEPT >/dev/null 2>&1
	iptables -I INPUT -p tcp --dport 6881:6889 -j ACCEPT >/dev/null 2>&1
	iptables -I INPUT -p tcp --dport $aria2_listen_port -j ACCEPT >/dev/null 2>&1
	iptables -I INPUT -p tcp --dport $aria2_listen_port -j ACCEPT >/dev/null 2>&1
	iptables -I INPUT -p udp --dport $aria2_listen_port -j ACCEPT >/dev/null 2>&1
	echo done
}

close_port(){
	echo close firewall port $aria2_rpc_listen_port and 8088
	iptables -D INPUT -p tcp --dport $aria2_rpc_listen_port -j ACCEPT >/dev/null 2>&1
	iptables -D INPUT -p tcp --dport 8088 -j ACCEPT >/dev/null 2>&1
	iptables -D INPUT -p tcp --dport 6881:6889 -j ACCEPT >/dev/null 2>&1
	iptables -D INPUT -p tcp --dport $aria2_listen_port -j ACCEPT >/dev/null 2>&1
	iptables -D INPUT -p tcp --dport $aria2_listen_port -j ACCEPT >/dev/null 2>&1
	iptables -D INPUT -p udp --dport $aria2_listen_port -j ACCEPT >/dev/null 2>&1
	echo done
}

creat_start_up(){
	[ ! -L "/etc/rc.d/S96aria2.sh" ] && ln -sf /koolshare/init.d/S96aria2.sh /etc/rc.d/S96aria2.sh
}

if [ "$aria2_enable" == "1" ];then
	kill_aria2
	close_port
	sleep 1
	creat_conf
	generate_token
	start_aria2
	open_port
	creat_start_up
	http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'
else
	kill_aria2
	close_port
	http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'
fi
