#!/bin/sh
#set -x

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
export PERP_BASE=$KSROOT/perp
mkdir -p /tmp/upload

# change port for httpd if it's not 9527
lanport=$(nvram get http_lanport)
if [ "$lanport" != "9527" ]; then
	nvram set http_lanport1=$lanport
	nvram set http_lanport=9527
	nvram commit
	sleep 1
	if [ -n `pidof httpd` ];then
		service httpd restart
	fi
fi

# ===============================
# start perp
echo start perp skipd and httpdb
sh $KSROOT/perp/perp.sh start

# ===============================

# set ks_nat to 1
router_status=`date | grep -E "UTC 1970"`
if [ -n "$router_status" ];then
	# if not empty, the ntp is not sync, indicating the router is booting
	nvram set ks_nat="1"
else
	# if empty, the ntp is finished sync, indicating user behavior running this scripts
	nvram set ks_nat="0"
fi

# write PATH to profile (for advanced ssh user to easily access koolshare binary and scripts)
mkdir -p /jffs/etc
[ ! -L "/jffs/etc/profile" ] && ln -sf $KSROOT/scripts/base.sh /jffs/etc/profile


# ===============================
# define start up for wan and nat
# now check if wan-start api exist
script_wanup=`nvram get script_wanup`
if [ -n "$script_wanup" ];then
wanstart=`echo $script_wanup | grep -E "$KSROOT/bin/ks-wan-start.sh"`
if [ -n "$wanstart" ];then
echo wan start for ks-wan-start.sh already exist, do nothing!
else
echo append wan start command!
nvram set script_wanup="#Do not delete ks-wan-start.sh! It's very important for software center!!!
$KSROOT/bin/ks-wan-start.sh
$script_wanup"
fi
else
echo create wan start command!
nvram set script_wanup="#Do not delete ks-wan-start.sh! It's very important for software center!!!
$KSROOT/bin/ks-wan-start.sh"
fi

# now check if firewall-start api exist
script_fire=`nvram get script_fire`
if [ -n "$script_fire" ];then
natstart=`echo $script_fire | grep -E "$KSROOT/bin/ks-nat-start.sh"`
if [ -n "$natstart" ];then
echo start up for ks-nat-start.sh already exist, do nothing!
else
echo append wan start command!
nvram set script_fire="#Do not delete nat.sh! It's important for software center!!!
$KSROOT/bin/ks-nat-start.sh
$script_fire"
fi
else
echo create nat start command!
nvram set script_fire="#Do not delete kscore.sh! It's important for software center!!!
$KSROOT/bin/ks-nat-start.sh"
fi

# now check if init-start api exist
script_init=`nvram get script_init`
if [ -n "$script_init" ];then
kscore=`echo $script_init | grep -E "$KSROOT/bin/kscore.sh"`
if [ -n "$kscore" ];then
echo wan start for kscore already exist, do nothing!
else
echo append wan start command!
nvram set script_init="#Do not delete kscore.sh! It's very important for software center!!!
$KSROOT/bin/kscore.sh
$script_init"
fi
else
echo create init start command!
nvram set script_init="#Do not delete kscore.sh! #It's very important for software center!!!
$KSROOT/bin/kscore.sh"
fi

# save changes
nvram commit
# ===============================
# now creat dnsmasq api
mkdir -p /jffs/etc/dnsmasq.d
[ -f "/jffs/etc/dnsmasq.custom" ] && conf_ok=`cat /jffs/etc/dnsmasq.custom|grep -E "conf-dir|koolshare"|wc -l` || conf_ok=0
if [ "$conf_ok" != "2" ];then
	cat > /jffs/etc/dnsmasq.custom <<-EOF
	# koolshare modified
	conf-dir=/jffs/etc/dnsmasq.d
	EOF
	service dnsmasq restart
fi
[ ! -L "/etc/dnsmasq.custom" ] && ln -sf /jffs/etc/dnsmasq.custom /etc/dnsmasq.custom
