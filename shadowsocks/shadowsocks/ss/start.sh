#!/bin/sh
#--------------------------------------------------------------------------------------
# Variable definitions
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
source $KSROOT/bin/helper.sh
eval `dbus export ss`
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
DNS_PORT=7913
CONFIG_FILE=$KSROOT/ss/ss.json
game_on=`dbus list ss_acl_mode|cut -d "=" -f 2 | grep 3`
[ -n "$game_on" ] || [ "$ss_basic_mode" == "3" ] && mangle=1
internet=`nvram get wan_proto`
if [ "$internet" == "dhcp" ];then
	ISP_DNS1=`nvram get wan_get_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 1p`
	ISP_DNS2=`nvram get wan_get_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 2p`
else
	ISP_DNS1=$(nvram get wan_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 1p)
	ISP_DNS2=$(nvram get wan_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 2p)
fi
# dns for china
[ "$ss_dns_china" == "1" ] && [ ! -z "$ISP_DNS1" ] && CDN="$ISP_DNS1"
[ "$ss_dns_china" == "1" ] && [ -z "$ISP_DNS1" ] && CDN="114.114.114.114"
[ "$ss_dns_china" == "2" ] && CDN="223.5.5.5"
[ "$ss_dns_china" == "3" ] && CDN="223.6.6.6"
[ "$ss_dns_china" == "4" ] && CDN="114.114.114.114"
[ "$ss_dns_china" == "5" ] && CDN="114.114.115.115"
[ "$ss_dns_china" == "6" ] && CDN="1.2.4.8"
[ "$ss_dns_china" == "7" ] && CDN="210.2.4.8"
[ "$ss_dns_china" == "8" ] && CDN="112.124.47.27"
[ "$ss_dns_china" == "9" ] && CDN="114.215.126.16"
[ "$ss_dns_china" == "10" ] && CDN="180.76.76.76"
[ "$ss_dns_china" == "11" ] && CDN="119.29.29.29"
[ "$ss_dns_china" == "12" ] && CDN="$ss_dns_china_user"
# dns for foreign ss-tunnel
[ "$ss_sstunnel" == "1" ] && gs="208.67.220.220:53"
[ "$ss_sstunnel" == "2" ] && gs="8.8.8.8:53"
[ "$ss_sstunnel" == "3" ] && gs="8.8.4.4:53"
[ "$ss_sstunnel" == "4" ] && gs="$ss_sstunnel_user"	
# dns for pdnsd upstream ss-tunnel
[ "$ss_pdnsd_udp_server_ss_tunnel" == "1" ] && dns1="208.67.220.220:53"
[ "$ss_pdnsd_udp_server_ss_tunnel" == "2" ] && dns1="8.8.8.8:53"
[ "$ss_pdnsd_udp_server_ss_tunnel" == "3" ] && dns1="8.8.4.4:53"
[ "$ss_pdnsd_udp_server_ss_tunnel" == "4" ] && dns1="$ss_pdnsd_udp_server_ss_tunnel_user"
# dns for foreign dns: chinaDNS dns for china
[ "$ss_chinadns_china" == "1" ] && rcc="223.5.5.5"
[ "$ss_chinadns_china" == "2" ] && rcc="223.6.6.6"
[ "$ss_chinadns_china" == "3" ] && rcc="114.114.114.114"
[ "$ss_chinadns_china" == "4" ] && rcc="114.114.115.115"
[ "$ss_chinadns_china" == "5" ] && rcc="1.2.4.8"
[ "$ss_chinadns_china" == "6" ] && rcc="210.2.4.8"
[ "$ss_chinadns_china" == "7" ] && rcc="112.124.47.27"
[ "$ss_chinadns_china" == "8" ] && rcc="114.215.126.16"
[ "$ss_chinadns_china" == "9" ] && rcc="180.76.76.76"
[ "$ss_chinadns_china" == "10" ] && rcc="119.29.29.29"
[ "$ss_chinadns_china" == "11" ] && rcc="$ss_chinadns_china_user"
# dns for foreign dns: chinaDNS foreign dns:dns2socks
[ "$ss_chinadns_foreign_dns2socks" == "1" ] && rcfd="208.67.220.220:53"
[ "$ss_chinadns_foreign_dns2socks" == "2" ] && rcfd="8.8.8.8:53"
[ "$ss_chinadns_foreign_dns2socks" == "3" ] && rcfd="8.8.4.4:53"
[ "$ss_chinadns_foreign_dns2socks" == "4" ] && rcfd="$ss_chinadns_foreign_dns2socks_user"
# dns for foreign dns: chinaDNS foreign dns:ss-tunnel
[ "$ss_chinadns_foreign_sstunnel" == "1" ] && rcfs="208.67.220.220:53"
[ "$ss_chinadns_foreign_sstunnel" == "2" ] && rcfs="8.8.8.8:53"
[ "$ss_chinadns_foreign_sstunnel" == "3" ] && rcfs="8.8.4.4:53"
[ "$ss_chinadns_foreign_sstunnel" == "4" ] && rcfs="$ss_chinadns_foreign_sstunnel_user"
# ==========================================================================================
# stop first
redsocks2=$(ps | grep "redsocks2" | grep -v "grep")
dnscrypt=$(ps | grep "dnscrypt-proxy" | grep -v "grep")
ssredir=$(ps | grep "ss-redir" | grep -v "grep" | grep -vw "rss-redir")
rssredir=$(ps | grep "rss-redir" | grep -v "grep" | grep -vw "ss-redir")
sstunnel=$(ps | grep "ss-tunnel" | grep -v "grep" | grep -vw "rss-tunnel")
rsstunnel=$(ps | grep "rss-tunnel" | grep -v "grep" | grep -vw "ss-tunnel")
pdnsd=$(ps | grep "pdnsd" | grep -v "grep")
chinadns=$(ps | grep "chinadns" | grep -v "grep")
DNS2SOCK=$(ps | grep "dns2socks" | grep -v "grep")
Pcap_DNSProxy=$(ps | grep "Pcap_DNSProxy" | grep -v "grep")
lan_ipaddr=$(nvram get lan_ipaddr)
ip_rule_exist=`/usr/sbin/ip rule show | grep "fwmark 0x1/0x1 lookup 310" | grep -c 310`
#--------------------------------------------------------------------------
restore_conf(){
	# delete server setting in dnsmasq.conf
	pc_delete "server=" "/jffs/etc/dnsmasq.custom"
	pc_delete "all-servers" "/jffs/etc/dnsmasq.custom"
	pc_delete "no-resolv" "/jffs/etc/dnsmasq.custom"
	pc_delete "no-poll" "/jffs/etc/dnsmasq.custom"

	# delete custom.conf
	if [ -f /jffs/etc/dnsmasq.d/custom.conf ];then
		echo_date 删除 /jffs/etc/dnsmasq.d/custom.conf
		rm -rf /jffs/etc/dnsmasq.d/custom.conf
	fi
	echo_date 删除ss相关的名单配置文件.
	# remove conf under /jffs/etc/dnsmasq.d
	rm -rf /jffs/etc/dnsmasq.d/gfwlist.conf
	rm -rf /jffs/etc/dnsmasq.d/cdn.conf
	rm -rf /jffs/etc/dnsmasq.d/custom.conf
	rm -rf /jffs/etc/dnsmasq.d/wblist.conf
	rm -rf /tmp/sscdn.conf
	rm -rf /tmp/custom.conf
	rm -rf /tmp/wblist.conf
	rm -rf /jffs/etc/dnsmasq.conf.add
}

restore_nat(){
	# flush iptables and destory SHADOWSOCKS chain
	iptables -t nat -D PREROUTING -p tcp -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_GFW > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_GFW > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_CHN > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_CHN > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_GAM > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_GAM > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_GLO > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_GLO > /dev/null 2>&1
	iptables -t mangle -D PREROUTING -p udp -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t mangle -F SHADOWSOCKS >/dev/null 2>&1 && iptables -t mangle -X SHADOWSOCKS >/dev/null 2>&1
	iptables -t mangle -F SHADOWSOCKS_GAM > /dev/null 2>&1 && iptables -t mangle -X SHADOWSOCKS_GAM > /dev/null 2>&1
	iptables -t nat -D OUTPUT -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-ports 3333 >/dev/null 2>&1
	iptables -t nat -D PREROUTING -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
	
	/usr/sbin/ip route del local 0.0.0.0/0 dev lo table 310 >/dev/null 2>&1
}

destory_ipset(){
	# flush and destory ipset
	ipset -F chnroute >/dev/null 2>&1
	ipset -F white_list >/dev/null 2>&1
	ipset -F black_list >/dev/null 2>&1
	ipset -F gfwlist >/dev/null 2>&1
	ipset -X chnroute >/dev/null 2>&1
	ipset -X white_list >/dev/null 2>&1
	ipset -X black_list >/dev/null 2>&1
	ipset -X gfwlist >/dev/null 2>&1
}

restore_start_file(){
	echo_date 清除nat-start, wan-start中相关的SS启动命令...
	rm -rf $KSROOT/init.d/N90shadowsocks.sh  >/dev/null 2>&1
	rm -rf $KSROOT/init.d/S90shadowsocks.sh  >/dev/null 2>&1
}

kill_process(){
	#--------------------------------------------------------------------------
	# kill dnscrypt-proxy
	if [ -n "$dnscrypt" ]; then 
		echo_date 关闭dnscrypt-proxy进程...
		killall dnscrypt-proxy
	fi
	# kill redsocks2
	if [ -n "$redsocks2" ]; then 
		echo_date 关闭redsocks2进程...
		killall redsocks2
	fi
	# kill ss-redir
	if [ -n "$ssredir" ];then 
		echo_date 关闭ss-redir进程...
		killall ss-redir
	fi
	if [ -n "$rssredir" ];then 
		echo_date 关闭ssr-redir进程...
		killall rss-redir
	fi
	# kill ss-local
	sslocal=`ps | grep ss-local | grep -v "grep" | grep -w "23456" | awk '{print $1}'`
	if [ -n "$sslocal" ];then 
		echo_date 关闭ss-local进程:23456端口...
		kill -9 $sslocal  >/dev/null 2>&1
	fi
	ssrlocal=`ps | grep rss-local | grep -v "grep" | grep -w "23456" | awk '{print $1}'`
	if [ -n "$ssrlocal" ];then 
		echo_date 关闭ssr-local进程:23456端口...
		kill -9 $ssrlocal  >/dev/null 2>&1
	fi
	# kill ss-tunnel
	if [ -n "$sstunnel" ];then 
		echo_date 关闭ss-tunnel进程...
		killall ss-tunnel
	fi
	if [ -n "$rsstunnel" ];then 
		echo_date 关闭rss-tunnel进程...
		killall rss-tunnel
	fi
	# kill pdnsd
	if [ -n "$pdnsd" ];then 
	echo_date 关闭pdnsd进程...
	killall pdnsd
	fi
	# kill Pcap_DNSProxy
	if [ -n "$Pcap_DNSProxy" ];then 
	echo_date 关闭Pcap_DNSProxy进程...
	pid1=`ps|grep $KSROOT/ss/dns/dns.sh | grep -v grep | awk '{print $1}'`
	kill -9 $pid1 >/dev/null 2>&1
	killall Pcap_DNSProxy >/dev/null 2>&1
	fi
	# kill chinadns
	if [ -n "$chinadns" ];then 
		echo_date 关闭chinadns进程...
		killall chinadns
	fi
	# kill dns2socks
	if [ -n "$DNS2SOCK" ];then 
		echo_date 关闭dns2socks进程...
		killall dns2socks
	fi
}

kill_cron_job(){
	jobexist=`cru l|grep ssupdate`
	if [ -n "$jobexist" ];then
		echo_date 删除ss规则定时更新任务.
		sed -i '/ssupdate/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}

# ==========================================================================================
# try to resolv the ss server ip if it is domain...
resolv_server_ip(){
	IFIP=`echo $ss_basic_server|grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}|:"`
	if [ -z "$IFIP" ];then
		echo_date 使用nslookup方式解析SS服务器的ip地址,解析dns：$ss_basic_dnslookup_server
		if [ "$ss_basic_dnslookup" == "1" ];then
			server_ip=`nslookup "$ss_basic_server" $ss_basic_dnslookup_server | sed '1,4d' | awk '{print $3}' | grep -v :|awk 'NR==1{print}'`
		else
			echo_date 使用resolveip方式解析SS服务器的ip地址.
			server_ip=`resolveip -4 -t 2 $ss_basic_server|awk 'NR==1{print}'`
		fi

		if [ -n "$server_ip" ];then
			echo_date SS服务器的ip地址解析成功：$server_ip.
			ss_basic_server="$server_ip"
			dbus set ss_basic_server_ip="$server_ip"
			dbus set ss_basic_dns_success="1"
		else
			echo_date SS服务器的ip地址解析失败，将由ss-redir自己解析.
			dbus set ss_basic_dns_success="0"
		fi
	else
		echo_date 检测到你的SS服务器已经是IP格式：$ss_basic_server,跳过解析... 
		dbus set ss_basic_dns_success="1"
	fi
}
# create shadowsocks config file...
creat_ss_json(){
	echo_date 创建SS配置文件到$CONFIG_FILE
	if [ "$ss_basic_type" == "0" ];then
		cat > $CONFIG_FILE <<-EOF
			{
			    "server":"$ss_basic_server",
			    "server_port":$ss_basic_port,
			    "local_port":3333,
			    "password":"$ss_basic_password",
			    "timeout":600,
			    "method":"$ss_basic_method"
			}
		EOF
	elif [ "$ss_basic_type" == "1" ];then
		cat > $CONFIG_FILE <<-EOF
			{
			    "server":"$ss_basic_server",
			    "server_port":$ss_basic_port,
			    "local_port":3333,
			    "password":"$ss_basic_password",
			    "timeout":600,
			    "protocol":"$ss_basic_rss_protocal",
			    "protocol_param":"$ss_basic_rss_protocal_para",
			    "obfs":"$ss_basic_rss_obfs",
			    "obfs_para":"$ss_basic_rss_obfs_para",
			    "method":"$ss_basic_method"
			}
		EOF
	fi
}

start_sslocal(){
	if [ "$ss_basic_type" == "1" ];then
	echo_date 开启ss-local，提供socks5端口：23456
		rss-local -b 0.0.0.0 -l 23456 -c $CONFIG_FILE -u -f /var/run/sslocal1.pid >/dev/null 2>&1
	elif  [ "$ss_basic_type" == "0" ];then
		ss-local -b 0.0.0.0 -l 23456 -c $CONFIG_FILE -u -f /var/run/sslocal1.pid >/dev/null 2>&1
	fi
}

start_dns(){
	# Start DNS2SOCKS
	if [ "1" == "$ss_dns_foreign" ] || [ -z "$ss_dns_foreign" ]; then
		start_sslocal
		echo_date 开启dns2socks，监听端口：23456
		dns2socks 127.0.0.1:23456 "$ss_dns2socks_user" 127.0.0.1:$DNS_PORT > /dev/null 2>&1 &
	fi

	# Start ss-tunnel
	if [ "2" == "$ss_dns_foreign" ];then
		if [ "$ss_basic_type" == "1" ];then
			echo_date 开启ssr-tunnel...
			rss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -c $CONFIG_FILE -l $DNS_PORT -L "$gs" -u -f /var/run/sstunnel.pid >/dev/null 2>&1
		elif  [ "$ss_basic_type" == "0" ];then
			echo_date 开启ss-tunnel...
			ss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -c $CONFIG_FILE -l $DNS_PORT -L "$gs" -u -f /var/run/sstunnel.pid >/dev/null 2>&1
		fi
	fi

	# Start dnscrypt-proxy
	if [ "3" == "$ss_dns_foreign" ] && [ "$ss_basic_enable" != "0" ];then
		echo_date 开启 dnscrypt-proxy，你选择了"$ss_opendns"节点.
		dnscrypt-proxy -a 127.0.0.1:$DNS_PORT -d -L $KSROOT/ss/rules/dnscrypt-resolvers.csv -R $ss_opendns >/dev/null 2>&1 &
	fi
	
	# Start pdnsd
	if [ "4" == "$ss_dns_foreign"  ]; then
		echo_date 开启 pdnsd，pdnsd进程可能会不稳定，请自己斟酌.
		echo_date 创建$KSROOT/ss/pdnsd文件夹.
		mkdir -p $KSROOT/ss/pdnsd
		if [ "$ss_pdnsd_method" == "1" ];then
			echo_date 创建pdnsd配置文件到$KSROOT/ss/pdnsd/pdnsd.conf
			echo_date 你选择了-仅udp查询-，需要开启上游dns服务，以防止dns污染.
			cat > $KSROOT/ss/pdnsd/pdnsd.conf <<-EOF
				global {
					perm_cache=2048;
					cache_dir="$KSROOT/ss/pdnsd/";
					run_as="nobody";
					server_port = $DNS_PORT;
					server_ip = 127.0.0.1;
					status_ctl = on;
					query_method=udp_only;
					min_ttl=$ss_pdnsd_server_cache_min;
					max_ttl=$ss_pdnsd_server_cache_max;
					timeout=10;
				}
				
				server {
					label= "RT-AC68U"; 
					ip = 127.0.0.1;
					port = 1099;
					root_server = on;   
					uptest = none;    
				}
				EOF
			if [ "$ss_pdnsd_udp_server" == "1" ];then
				# start ss-local on port 23456
				start_sslocal
				echo_date 开启dns2socks作为pdnsd的上游服务器.
				dns2socks 127.0.0.1:23456 "$ss_pdnsd_udp_server_dns2socks" 127.0.0.1:1099 > /dev/null 2>&1 &
			elif [ "$ss_pdnsd_udp_server" == "2" ];then
				echo_date 开启dnscrypt-proxy作为pdnsd的上游服务器.
				dnscrypt-proxy --local-address=127.0.0.1:1099 --daemonize -L $KSROOT/ss/rules/dnscrypt-resolvers.csv -R "$ss_pdnsd_udp_server_dnscrypt"
			elif [ "$ss_pdnsd_udp_server" == "3" ];then
				if [ "$ss_basic_type" == "1" ];then
					echo_date 开启ssr-tunnel作为pdnsd的上游服务器.
					rss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -c $CONFIG_FILE -l 1099 -L "$dns1" -u -f /var/run/sstunnel.pid >/dev/null 2>&1
				elif  [ "$ss_basic_type" == "0" ];then
					echo_date 开启ss-tunnel作为pdnsd的上游服务器.
					ss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -c $CONFIG_FILE -l $DNS_PORT -L "$dns1" -u -f /var/run/sstunnel.pid >/dev/null 2>&1
				fi
			fi
		elif [ "$ss_pdnsd_method" == "2" ];then
			echo_date 创建pdnsd配置文件到$KSROOT/ss/pdnsd/pdnsd.conf
			echo_date 你选择了-仅tcp查询-，使用"$ss_pdnsd_server_ip":"$ss_pdnsd_server_port"进行tcp查询.
			cat > $KSROOT/ss/pdnsd/pdnsd.conf <<-EOF
				global {
					perm_cache=2048;
					cache_dir="$KSROOT/ss/pdnsd/";
					run_as="nobody";
					server_port = $DNS_PORT;
					server_ip = 127.0.0.1;
					status_ctl = on;
					query_method=tcp_only;
					min_ttl=$ss_pdnsd_server_cache_min;
					max_ttl=$ss_pdnsd_server_cache_max;
					timeout=10;
				}
				
				server {
					label= "RT-AC68U"; 
					ip = $ss_pdnsd_server_ip;
					port = $ss_pdnsd_server_port;
					root_server = on;   
					uptest = none;    
				}
				EOF
		fi
		
		chmod 644 $KSROOT/ss/pdnsd/pdnsd.conf
		CACHEDIR=$KSROOT/ss/pdnsd
		CACHE=$KSROOT/ss/pdnsd/pdnsd.cache
		USER=nobody
		GROUP=nogroup
	
		if ! test -f "$CACHE"; then
			echo_date 创建pdnsd缓存文件.
			dd if=/dev/zero of=$KSROOT/ss/pdnsd/pdnsd.cache bs=1 count=4 2> /dev/null
			chown -R $USER.$GROUP $CACHEDIR 2> /dev/null
		fi

		echo_date 启动pdnsd进程...
		pdnsd --daemon -c $KSROOT/ss/pdnsd/pdnsd.conf -p /var/run/pdnsd.pid
	fi

	# Start chinadns
	if [ "5" == "$ss_dns_foreign" ];then
		echo_date ┏ 你选择了chinaDNS作为解析方案！
		if [ "$ss_chinadns_foreign_method" == "1" ];then
			echo_date ┣ 开启ss-local,为dns2socks提供socks5端口：23456
			start_sslocal
			echo_date ┣ 开启dns2socks，作为chinaDNS上游国外dns，转发dns：$rcfd
			dns2socks 127.0.0.1:23456 "$rcfd" 127.0.0.1:1055 >/dev/null 2>&1 &
		elif [ "$ss_chinadns_foreign_method" == "2" ];then
			echo_date ┣ 开启 dnscrypt-proxy，作为chinaDNS上游国外dns，你选择了"$ss_chinadns_foreign_dnscrypt"节点.
			dnscrypt-proxy --local-address=127.0.0.1:1055 --daemonize -L $KSROOT/ss/rules/dnscrypt-resolvers.csv -R $ss_chinadns_foreign_dnscrypt >/dev/null 2>&1
		elif [ "$ss_chinadns_foreign_method" == "3" ];then
			if [ "$ss_basic_type" == "1" ];then
				echo_date ┣ 开启ssr-tunnel，作为chinaDNS上游国外dns，转发dns：$rcfs
				rss-tunnel -b 127.0.0.1 -s $ss_basic_server -p $ss_basic_port -c $CONFIG_FILE -l 1055 -L "$rcfs" -u -f /var/run/sstunnel.pid >/dev/null 2>&1
			elif  [ "$ss_basic_type" == "0" ];then
				echo_date ┣ 开启ss-tunnel，作为chinaDNS上游国外dns，转发dns：$rcfs
				ss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -c $CONFIG_FILE -l 1055 -L "$rcfs" -u -f /var/run/sstunnel.pid
			fi
		elif [ "$ss_chinadns_foreign_method" == "4" ];then
			echo_date ┣ 你选择了自定义chinadns国外dns！dns：$ss_chinadns_foreign_method_user
		fi
		echo_date ┗ 开启chinadns进程！
		chinadns -p $DNS_PORT -s "$rcc",127.0.0.1:1055 -m -d -c $KSROOT/ss/rules/chnroute.txt  >/dev/null 2>&1 &
	fi
	
	# Start Pcap_DNSProxy
	if [ "6" == "$ss_dns_foreign"  ]; then
			echo_date 开启Pcap_DNSProxy..
			sed -i "/^Listen Port/c Listen Port = $DNS_PORT" $KSROOT/ss/dns/Config.ini
			#sed -i '/^Local Main/c Local Main = 0' $KSROOT/ss/dns/Config.conf
			sh $KSROOT/ss/dns/dns.sh > /dev/null 2>&1 &
	fi
}
#--------------------------------------------------------------------------------------

load_cdn_site(){
	# append china site
	rm -rf /tmp/sscdn.conf
	if [ "$ss_dns_plan" == "2" ] && [ "$ss_dns_foreign" != "5" ] && [ "$ss_dns_foreign" != "6" ];then
		echo_date 生成cdn加速列表到/tmp/sscdn.conf，加速用的dns：$CDN
		echo "#for china site CDN acclerate" >> /tmp/sscdn.conf
		cat $KSROOT/ss/rules/cdn.txt | sed "s/^/server=&\/./g" | sed "s/$/\/&$CDN/g" | sort | awk '{if ($0!=line) print;line=$0}' >>/tmp/sscdn.conf
	fi

	# append user defined china site
	if [ -n "$ss_isp_website_web" ];then
		cdnsites=$(echo $ss_isp_website_web | base64_decode)
		echo_date 生成自定义cdn加速域名到/tmp/sscdn.conf
		echo "#for user defined china site CDN acclerate" >> /tmp/sscdn.conf
		for cdnsite in $cdnsites
		do
			echo "$cdnsite" | sed "s/^/server=&\/./g" | sed "s/$/\/&$CDN/g" >> /tmp/sscdn.conf
		done
	fi
}

custom_dnsmasq(){
	rm -rf /tmp/custom.conf
	if [ -n "$ss_dnsmasq" ];then
		echo_date 添加自定义dnsmasq设置到/tmp/custom.conf
		echo "$ss_dnsmasq" | base64_decode | sort -u >> /tmp/custom.conf
	fi
}

append_white_black_conf(){
	# append white domain list, bypass ss
	rm -rf /tmp/wblist.conf
	# github need to go ss
	echo "#for router itself" >> /tmp/wblist.conf
	echo "server=/.google.com.tw/127.0.0.1#7913" >> /tmp/wblist.conf
	echo "ipset=/.google.com.tw/router" >> /tmp/wblist.conf
	echo "server=/.github.com/127.0.0.1#7913" >> /tmp/wblist.conf
	echo "ipset=/.github.com/router" >> /tmp/wblist.conf
	echo "server=/.github.io/127.0.0.1#7913" >> /tmp/wblist.conf
	echo "ipset=/.github.io/router" >> /tmp/wblist.conf
	echo "server=/.raw.githubusercontent.com/127.0.0.1#7913" >> /tmp/wblist.conf
	echo "ipset=/.raw.githubusercontent.com/router" >> /tmp/wblist.conf
	# append white domain list,not through ss
	wanwhitedomain=$(echo $ss_wan_white_domain | base64_decode)
	if [ -n "$ss_wan_white_domain" ];then
		echo_date 应用域名白名单
		echo "#for white_domain" >> //tmp/wblist.conf
		for wan_white_domain in $wanwhitedomain
		do 
			echo "$wan_white_domain" | sed "s/^/server=&\/./g" | sed "s/$/\/127.0.0.1#7913/g" >> /tmp/wblist.conf
			echo "$wan_white_domain" | sed "s/^/ipset=&\/./g" | sed "s/$/\/white_list/g" >> /tmp/wblist.conf
		done
	fi
	# apple 和microsoft不能走ss
	echo "#for special site" >> //tmp/wblist.conf
	for wan_white_domain2 in "apple.com" "microsoft.com"
	do 
		echo "$wan_white_domain2" | sed "s/^/server=&\/./g" | sed "s/$/\/$CDN#53/g" >> /tmp/wblist.conf
		echo "$wan_white_domain2" | sed "s/^/ipset=&\/./g" | sed "s/$/\/white_list/g" >> /tmp/wblist.conf
	done
	
	# append black domain list,through ss
	wanblackdomain=$(echo $ss_wan_black_domain | base64_decode)
	if [ -n "$ss_wan_black_domain" ];then
		echo_date 应用域名黑名单
		echo "#for black_domain" >> /tmp/wblist.conf
		for wan_black_domain in $wanblackdomain
		do 
			echo "$wan_black_domain" | sed "s/^/server=&\/./g" | sed "s/$/\/127.0.0.1#7913/g" >> /tmp/wblist.conf
			echo "$wan_black_domain" | sed "s/^/ipset=&\/./g" | sed "s/$/\/black_list/g" >> /tmp/wblist.conf
		done
	fi
}

ln_conf(){
	# custom dnsmasq
	rm -rf /jffs/etc/dnsmasq.d/custom.conf
	if [ -f /tmp/custom.conf ];then
		echo_date 创建域自定义dnsmasq配置文件软链接到/jffs/etc/dnsmasq.d/custom.conf
		mv /tmp/custom.conf /jffs/etc/dnsmasq.d/custom.conf
	fi
	# custom dnsmasq
	rm -rf /jffs/etc/dnsmasq.d/wblist.conf
	if [ -f /tmp/wblist.conf ];then
		echo_date 创建域名黑/白名单软链接到/jffs/configs/dnsmasq.d/wblist.conf
		mv /tmp/wblist.conf /jffs/etc/dnsmasq.d/wblist.conf
	fi
	rm -rf /jffs/etc/dnsmasq.d/cdn.conf
	if [ -f /tmp/sscdn.conf ];then
		echo_date 创建cdn加速列表软链接/jffs/etc/dnsmasq.d/cdn.conf
		mv /tmp/sscdn.conf /jffs/etc/dnsmasq.d/cdn.conf
	fi
	gfw_on=`dbus list ss_acl_mode|cut -d "=" -f 2 | grep 1`	
	rm -rf /jffs/etc/dnsmasq.d/gfwlist.conf
	if [ "$ss_basic_mode" == "1" ];then
		ln -sf $KSROOT/ss/rules/gfwlist.conf /jffs/etc/dnsmasq.d/gfwlist.conf
	elif [ "$ss_basic_mode" == "2" ] || [ "$ss_basic_mode" == "3" ];then
		if [ ! -f /jffs/etc/dnsmasq.d/gfwlist.conf ] && [ "$ss_dns_plan" == "1" ] || [ -n "$gfw_on" ];then
			echo_date 创建gfwlist的软连接到/jffs/etc/dnsmasq.d/文件夹.
			ln -sf $KSROOT/ss/rules/gfwlist.conf /jffs/etc/dnsmasq.d/gfwlist.conf
		fi
	fi
	
	if [ "$ss_dns_china" == "1" ];then
		[ -n "$ISP_DNS1" ] && CDN1="$ISP_DNS1" || CDN1="114.114.114.114"
		[ -n "$ISP_DNS2" ] && CDN2="$ISP_DNS2" || CDN2="114.114.115.115"
	fi
	[ "$ss_dns_china" == "2" ] && CDN="223.5.5.5"
	[ "$ss_dns_china" == "3" ] && CDN="223.6.6.6"
	[ "$ss_dns_china" == "4" ] && CDN="114.114.114.114"
	[ "$ss_dns_china" == "5" ] && CDN="114.114.115.115"
	[ "$ss_dns_china" == "6" ] && CDN="1.2.4.8"
	[ "$ss_dns_china" == "7" ] && CDN="210.2.4.8"
	[ "$ss_dns_china" == "8" ] && CDN="112.124.47.27"
	[ "$ss_dns_china" == "9" ] && CDN="114.215.126.16"
	[ "$ss_dns_china" == "10" ] && CDN="180.76.76.76"
	[ "$ss_dns_china" == "11" ] && CDN="119.29.29.29"
	[ "$ss_dns_china" == "12" ] && CDN="$ss_dns_china_user"
	
	if [ "$ss_dns_plan" == "1" ] || [ -z "$ss_dns_china" ];then
		if [ "$ss_dns_china" == "1" ];then
			echo_date DNS解析方案国内优先，使用运营商DNS优先解析国内DNS.
			pc_insert "koolshare" "server=$CDN2#53" "/jffs/etc/dnsmasq.custom"
			pc_insert "koolshare" "server=$CDN1#53" "/jffs/etc/dnsmasq.custom"
			pc_insert "koolshare" "all-servers" "/jffs/etc/dnsmasq.custom"
		else
			echo_date DNS解析方案国内优先，使用自定义DNS：$CDN进行解析国内DNS.
			pc_insert "koolshare" "server=$CDN#53" "/jffs/etc/dnsmasq.custom"
		fi
	elif [ "$ss_dns_plan" == "2" ];then
		echo_date DNS解析方案国外优先，优先解析国外DNS.
		pc_insert "koolshare" "server=127.0.0.1#7913" "/jffs/etc/dnsmasq.custom"
	fi
	pc_insert "koolshare" "no-resolv" "/jffs/etc/dnsmasq.custom"
}

#--------------------------------------------------------------------------------------
nat_auto_start(){
	echo_date 添加nat-start触发事件...
	[ ! -L "$KSROOT/init.d/N90shadowsocks.sh" ] && ln -sf $KSROOT/ss/start.sh "$KSROOT"/init.d/N90shadowsocks.sh
}
#--------------------------------------------------------------------------------------
wan_auto_start(){
	echo_date 加入开机自动启动...
	[ ! -L "$KSROOT/init.d/S90shadowsocks.sh" ] && ln -sf $KSROOT/scripts/ss_config.sh "$KSROOT"/init.d/S90shadowsocks.sh
}

#=======================================================================================
start_ss_redir(){
	# Start ss-redir
	if [ "$ss_basic_type" == "1" ];then
		echo_date 开启ssr-redir进程，用于透明代理.
		rss-redir -b 0.0.0.0 -c $CONFIG_FILE -u -f /var/run/shadowsocks.pid >/dev/null 2>&1
	elif  [ "$ss_basic_type" == "0" ];then
		echo_date 开启ss-redir进程，用于透明代理.
		ss-redir -b 0.0.0.0 -c $CONFIG_FILE -u -f /var/run/shadowsocks.pid >/dev/null 2>&1
	fi
}

write_cron_job(){
	if [ "1" == "$ss_basic_rule_update" ]; then
		echo_date 添加ss规则定时更新任务，每天"$ss_basic_rule_update_time"自动检测更新规则.
		cru a ssupdate "0 $ss_basic_rule_update_time * * * /bin/sh $KSROOT/scripts/ss_rule_update.sh"
	else
		echo_date ss规则定时更新任务未启用！
	fi
}

# =======================================================================================================
flush_nat(){
	echo_date 尝试先清除已存在的iptables规则，防止重复添加
	# flush rules and set if any
	iptables -t nat -D PREROUTING -p tcp -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_GFW > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_GFW > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_CHN > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_CHN > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_GAM > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_GAM > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_GLO > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_GLO > /dev/null 2>&1
	iptables -t mangle -D PREROUTING -p udp -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t mangle -F SHADOWSOCKS >/dev/null 2>&1 && iptables -t mangle -X SHADOWSOCKS >/dev/null 2>&1
	iptables -t mangle -F SHADOWSOCKS_GAM > /dev/null 2>&1 && iptables -t mangle -X SHADOWSOCKS_GAM > /dev/null 2>&1
	iptables -t nat -D OUTPUT -p tcp -m set --match-set router dst -j REDIRECT --to-ports 3333 >/dev/null 2>&1
	iptables -t nat -D PREROUTING -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
}

flush_ipset(){
	echo_date 先清空已存在的ipset名单，防止重复添加
	ipset -F chnroute >/dev/null 2>&1 && ipset -X chnroute >/dev/null 2>&1
	ipset -F white_list >/dev/null 2>&1 && ipset -X white_list >/dev/null 2>&1
	ipset -F black_list >/dev/null 2>&1 && ipset -X black_list >/dev/null 2>&1
	ipset -F gfwlist >/dev/null 2>&1 && ipset -X gfwlist >/dev/null 2>&1
	ipset -F router >/dev/null 2>&1 && ipset -X router >/dev/null 2>&1
}

remove_redundant_rule(){
	ip_rule_exist=`/usr/sbin/ip rule show | grep "fwmark 0x1/0x1 lookup 310" | grep -c 310`
	#ip_rule_exist=`ip rule show | grep "fwmark 0x1/0x1 lookup 310" | grep -c 300`
	if [ ! -z "ip_rule_exist" ];then
		echo_date 清除重复的ip rule规则.
		until [ "$ip_rule_exist" = 0 ]
		do 
			#ip rule del fwmark 0x01/0x01 table 310
			/usr/sbin/ip rule del fwmark 0x01/0x01 table 310 pref 789
			ip_rule_exist=`expr $ip_rule_exist - 1`
		done
	fi
}

remove_route_table(){
	echo_date 删除ip route规则.
	/usr/sbin/ip route del local 0.0.0.0/0 dev lo table 310 >/dev/null 2>&1
}

# creat ipset rules
creat_ipset(){
	echo_date 创建ipset名单
	ipset -! create white_list nethash && ipset flush white_list
	ipset -! create black_list nethash && ipset flush black_list
	ipset -! create gfwlist nethash && ipset flush gfwlist
	ipset -! create router nethash && ipset flush router
	ipset -! create chnroute nethash && ipset flush chnroute
	sed -e "s/^/add chnroute &/g" $KSROOT/ss/rules/chnroute.txt | awk '{print $0} END{print "COMMIT"}' | ipset -R
}

add_white_black_ip(){
	# black ip/cidr
	ip_tg="149.154.0.0/16 91.108.4.0/22 91.108.56.0/24 109.239.140.0/24 67.198.55.0/24"
	for ip in $ip_tg
	do
		ipset -! add black_list $ip >/dev/null 2>&1
	done
	
	if [ ! -z $ss_wan_black_ip ];then
		ss_wan_black_ip=`dbus get ss_wan_black_ip|base64_decode|sed '/\#/d'`
		echo_date 应用IP/CIDR黑名单
		for ip in $ss_wan_black_ip
		do
			ipset -! add black_list $ip >/dev/null 2>&1
		done
	fi
	
	# white ip/cidr
	ip1=$(nvram get wan0_ipaddr | cut -d"." -f1,2)
	[ ! -z "$ss_basic_server_ip" ] && SERVER_IP=$ss_basic_server_ip || SERVER_IP=""
	ip_lan="0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.168.0.0/16 224.0.0.0/4 240.0.0.0/4 $ip1.0.0/16 $SERVER_IP 223.5.5.5 223.6.6.6 114.114.114.114 114.114.115.115 1.2.4.8 210.2.4.8 112.124.47.27 114.215.126.16 180.76.76.76 119.29.29.29 $ISP_DNS1 $ISP_DNS2"
	for ip in $ip_lan
	do
		ipset -! add white_list $ip >/dev/null 2>&1
	done
	
	if [ ! -z $ss_wan_white_ip ];then
		ss_wan_white_ip=`echo $ss_wan_white_ip|base64_decode|sed '/\#/d'`
		echo_date 应用IP/CIDR白名单
		for ip in $ss_wan_white_ip
		do
			ipset -! add white_list $ip >/dev/null 2>&1
		done
	fi
}

get_action_chain() {
	case "$1" in
		0)
			echo "RETURN"
		;;
		1)
			echo "SHADOWSOCKS_GFW"
		;;
		2)
			echo "SHADOWSOCKS_CHN"
		;;
		3)
			echo "SHADOWSOCKS_GAM"
		;;
		4)
			echo "SHADOWSOCKS_GLO"
		;;
	esac
}

get_mode_name() {
	case "$1" in
		0)
			echo "不通过SS"
		;;
		1)
			echo "gfwlist模式"
		;;
		2)
			echo "大陆白名单模式"
		;;
		3)
			echo "游戏模式"
		;;
		4)
			echo "全局模式"
		;;
	esac
}

factor(){
	if [ -z "$1" ] || [ -z "$2" ]; then
		echo ""
	else
		echo "$2 $1"
	fi
}

get_jump_mode(){
	case "$1" in
		0)
			echo "j"
		;;
		*)
			echo "g"
		;;
	esac
}

lan_acess_control(){
	# lan access control
	acl_nu=`dbus list ss_acl_mode|sort -n -t "=" -k 2|cut -d "=" -f 1 | cut -d "_" -f 4`
	if [ -n "$acl_nu" ]; then
		for acl in $acl_nu
		do
			ipaddr=`dbus get ss_acl_ip_$acl`
			ports=`dbus get ss_acl_port_$acl`
			[ "$ports" == "all" ] && ports=""
			proxy_mode=`dbus get ss_acl_mode_$acl`
			proxy_name=`dbus get ss_acl_name_$acl`
			proxy_mac=`dbus get ss_acl_mace_$acl`
			
			[ "$ports" == "" ] && echo_date 加载ACL规则：【$ipaddr】【$mac】:all模式为：$(get_mode_name $proxy_mode) || echo_date 加载ACL规则：$ipaddr:$ports模式为：$(get_mode_name $proxy_mode)

			iptables -t nat -A SHADOWSOCKS $(factor $ipaddr "-s") -p tcp $(factor $ports "-m multiport --dport") -$(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)

			[ "$proxy_mode" == "3" ] || [ "$proxy_mode" == "4" ] && \
			iptables -t mangle -A SHADOWSOCKS $(factor $ipaddr "-s") -p udp $(factor $ports "-m multiport --dport") -$(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
		done
		echo_date 加载ACL规则：其余主机模式为：$(get_mode_name $ss_acl_default_mode)
	else
		ss_acl_default_mode="$ss_basic_mode"
		echo_date 加载ACL规则：所有模式为：$(get_mode_name $ss_basic_mode)
	fi
}

apply_nat_rules(){
	#----------------------BASIC RULES---------------------
	echo_date 写入iptables规则到nat表中...
	# 创建SHADOWSOCKS nat rule
	iptables -t nat -N SHADOWSOCKS
	# IP/cidr/白域名 白名单控制（不走ss）
	iptables -t nat -A SHADOWSOCKS -p tcp -m set --match-set white_list dst -j RETURN
	#-----------------------FOR GLOABLE---------------------
	# 创建gfwlist模式nat rule
	iptables -t nat -N SHADOWSOCKS_GLO
	# IP黑名单控制-gfwlist（走ss）
	iptables -t nat -A SHADOWSOCKS_GLO -p tcp -j REDIRECT --to-ports 3333
	#-----------------------FOR GFWLIST---------------------
	# 创建gfwlist模式nat rule
	iptables -t nat -N SHADOWSOCKS_GFW
	# IP/CIDR/黑域名 黑名单控制（走ss）
	iptables -t nat -A SHADOWSOCKS_GFW -p tcp -m set --match-set black_list dst -j REDIRECT --to-ports 3333
	# IP黑名单控制-gfwlist（走ss）
	iptables -t nat -A SHADOWSOCKS_GFW -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-ports 3333
	#-----------------------FOR CHNMODE---------------------
	# 创建大陆白名单模式nat rule
	iptables -t nat -N SHADOWSOCKS_CHN
	# IP/CIDR/域名 黑名单控制（走ss）
	iptables -t nat -A SHADOWSOCKS_CHN -p tcp -m set --match-set black_list dst -j REDIRECT --to-ports 3333
	# cidr黑名单控制-chnroute（走ss）
	iptables -t nat -A SHADOWSOCKS_CHN -p tcp -m set ! --match-set chnroute dst -j REDIRECT --to-ports 3333
	#-----------------------FOR GAMEMODE---------------------
	# 创建大陆白名单模式nat rule
	iptables -t nat -N SHADOWSOCKS_GAM
	# IP/CIDR/域名 黑名单控制（走ss）
	iptables -t nat -A SHADOWSOCKS_GAM -p tcp -m set --match-set black_list dst -j REDIRECT --to-ports 3333
	# cidr黑名单控制-chnroute（走ss）
	iptables -t nat -A SHADOWSOCKS_GAM -p tcp -m set ! --match-set chnroute dst -j REDIRECT --to-ports 3333

	#[ "$mangle" == "1" ] && load_tproxy
	[ "$mangle" == "1" ] && /usr/sbin/ip rule add fwmark 0x01/0x01 table 310 pref 789
	[ "$mangle" == "1" ] && /usr/sbin/ip route add local 0.0.0.0/0 dev lo table 310
	# 创建游戏模式udp rule
	[ "$mangle" == "1" ] && iptables -t mangle -N SHADOWSOCKS
	# IP/cidr/白域名 白名单控制（不走ss）
	[ "$mangle" == "1" ] && iptables -t mangle -A SHADOWSOCKS -p udp -m set --match-set white_list dst -j RETURN
	# 创建游戏模式udp rule
	[ "$mangle" == "1" ] && iptables -t mangle -N SHADOWSOCKS_GAM
	# IP/CIDR/域名 黑名单控制（走ss）
	[ "$mangle" == "1" ] && iptables -t mangle -A SHADOWSOCKS_GAM -p udp -m set --match-set black_list dst -j TPROXY --on-port 3333 --tproxy-mark 0x01/0x01
	# cidr黑名单控制-chnroute（走ss）
	[ "$mangle" == "1" ] && iptables -t mangle -A SHADOWSOCKS_GAM -p udp -m set ! --match-set chnroute dst -j TPROXY --on-port 3333 --tproxy-mark 0x01/0x01
	#-----------------------FOR ROUTER---------------------
	# router itself
	iptables -t nat -A OUTPUT -p tcp -m set --match-set router dst -j REDIRECT --to-ports 3333
	#-------------------------------------------------------
	# 局域网黑名单（不走ss）/局域网黑名单（走ss）
	lan_acess_control
	# 把最后剩余流量重定向到相应模式的nat表中对对应的主模式的链
	[ "$ss_acl_default_port" == "all" ] && ss_acl_default_port=""
	iptables -t nat -A SHADOWSOCKS -p tcp $(factor $ss_acl_default_port "-m multiport --dport") -j $(get_action_chain $ss_acl_default_mode)
	# 如果是主模式游戏模式，则把SHADOWSOCKS链中剩余udp流量转发给SHADOWSOCKS_GAM链
	# 如果主模式不是游戏模式，则不需要把SHADOWSOCKS链中剩余udp流量转发给SHADOWSOCKS_GAM，不然会造成其他模式主机的udp也走游戏模式
	[ "$mangle" == "1" ] && ss_acl_default_mode=3
	[ "$ss_basic_mode" == "3" ] && iptables -t mangle -A SHADOWSOCKS -p udp -j $(get_action_chain $ss_acl_default_mode)
	# 重定所有流量到 SHADOWSOCKS
	iptables -t nat -I PREROUTING 1 -p tcp -j SHADOWSOCKS
	[ "$mangle" == "1" ] && iptables -t mangle -I PREROUTING 1 -p udp -j SHADOWSOCKS
}

chromecast(){
	LOG1=开启chromecast功能（DNS劫持功能）
	LOG2=chromecast功能未开启，建议开启~
	if [ "$ss_basic_chromecast" == "1" ];then
		IPT_ACTION="-A"
		echo_date $LOG1
	else
		IPT_ACTION="-D"
		echo_date $LOG2
	fi
	iptables -t nat $IPT_ACTION PREROUTING -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
}
# =======================================================================================================
#---------------------------------------------------------------------------------------------------------
load_nat(){
	nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep WANPREROUTING|grep -v destination)
	i=120
	until [ -n "$nat_ready" ]
	do
	    i=$(($i-1))
	    if [ "$i" -lt 1 ];then
	        echo_date "错误：不能正确加载nat规则!"
	        exit
	    fi
	    sleep 1
	done
	echo_date "加载nat规则!"
	flush_nat
	flush_ipset
	remove_redundant_rule
	remove_route_table
	creat_ipset
	add_white_black_ip
	apply_nat_rules
	chromecast
}

restart_dnsmasq(){
	# Restart dnsmasq
	echo_date 重启dnsmasq服务...
	service dnsmasq restart  >/dev/null 2>&1

}

load_module(){
	xt=`lsmod | grep xt_set`
	OS=$(uname -r)
	if [ -f /lib/modules/${OS}/kernel/net/netfilter/xt_set.ko ] && [ -z "$xt" ];then
		echo_date "加载ipset内核模块！"
		insmod ip_set
		insmod ip_set_bitmap_ip
		insmod ip_set_bitmap_ipmac
		insmod ip_set_bitmap_port
		insmod ip_set_hash_ip
		insmod ip_set_hash_ipport
		insmod ip_set_hash_ipportip
		insmod ip_set_hash_ipportnet
		insmod ip_set_hash_net
		insmod ip_set_hash_netport
		insmod ip_set_list_set
		insmod xt_set
	fi
	tproxy=`lsmod | grep tproxy`
	if [ -z "$tproxy" ];then
		echo_date "加载TPROXY内核模块！"
		cd $KSROOT/module
		insmod nf_tproxy_core.ko
		insmod xt_TPROXY.ko
		insmod xt_socket.ko
	fi
}

write_numbers(){
	ipset_numbers=`cat $KSROOT/ss/rules/gfwlist.conf | grep -c ipset`
	chnroute_numbers=`cat $KSROOT/ss/rules/chnroute.txt | grep -c .`
	cdn_numbers=`cat $KSROOT/ss/rules/cdn.txt | grep -c .`
	update_ipset=`cat $KSROOT/ss/rules/version | sed -n 1p | sed 's/#/\n/g'| sed -n 1p`
	update_chnroute=`cat $KSROOT/ss/rules/version | sed -n 2p | sed 's/#/\n/g'| sed -n 1p`
	update_cdn=`cat $KSROOT/ss/rules/version | sed -n 4p | sed 's/#/\n/g'| sed -n 1p`
	dbus set ss_gfw_status="$ipset_numbers 条，最后更新版本： $update_ipset "
	dbus set ss_chn_status="$chnroute_numbers 条，最后更新版本： $update_chnroute "
	dbus set ss_cdn_status="$cdn_numbers 条，最后更新版本： $update_cdn "
}

case $1 in
start_all)
	echo_date ---------------------- Advanced Tomato 固件 shadowsocks -----------------------
	# stop first
	restore_conf
	restore_nat
	destory_ipset
	restore_start_file
	kill_process
	kill_cron_job
	echo_date ---------------------------------------------------------------------------------------
	# start
	resolv_server_ip
	creat_ss_json
	load_cdn_site
	custom_dnsmasq
	append_white_black_conf && ln_conf
	nat_auto_start
	wan_auto_start
	write_cron_job
	start_ss_redir
	load_module
	load_nat
	restart_dnsmasq
	start_dns
	write_numbers
	echo_date ------------------------- shadowsocks 启动完毕 -------------------------
	;;
start_nat)
	flush_nat
	flush_ipset
	remove_redundant_rule
	remove_route_table
	creat_ipset
	add_white_black_ip
	apply_nat_rules
	chromecast
	;;
stop)
	echo_date ---------------------- Advanced Tomato 固件 shadowsocks -----------------------
	restore_conf
	restart_dnsmasq
	restore_nat
	remove_redundant_rule
	destory_ipset
	restore_start_file
	kill_process
	kill_cron_job
	echo_date ------------------------- shadowsocks 成功关闭 -------------------------
	;;
esac
