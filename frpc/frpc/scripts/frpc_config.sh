#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export frpc_`

conf_file="$KSROOT/frpc/frpc.ini"
version=`$KSROOT/frpc/frpc --version`
dbus set frpc_version=$version

write_conf(){
  if [ "`dbus get frpc_customize_conf`"x = "1"x ];then
    _frpc_customize_conf=`dbus get frpc_customize_config | base64_decode` || "未发现配置文件"
    cat > $conf_file<<-EOF
# frpc custom configuration
${_frpc_customize_conf}
EOF
  else
    # frpc configuration
    echo "[common]" > $conf_file
    dbus list frpc|grep "frpc_common"|grep -v '=$'|grep -v 'srlist'|sed 's/=/ = /g'|sed "s/frpc_common_//g" >> $conf_file
    for i in `dbus get frpc_srlist|sed 's/>/\n/g'`;do
        echo "[`echo $i|cut -d'<' -f1`]" >> $conf_file
        echo "type = `echo $i|cut -d'<' -f2`" >> $conf_file
        echo "custom_domains = `echo $i|cut -d'<' -f3`" >> $conf_file
        echo "local_ip = `echo $i|cut -d'<' -f4`" >> $conf_file
        echo "local_port = `echo $i|cut -d'<' -f5`" >> $conf_file
        echo "remote_port = `echo $i|cut -d'<' -f6`" >> $conf_file
        use_compression=`echo $i|cut -d'<' -f7`
        use_encryption=`echo $i|cut -d'<' -f8`
        #privilege_mode=`echo $i|cut -d'<' -f9`
        if [ $use_compression == "1" ];then
            echo "use_compression = true" >> $conf_file
        else
            echo "use_compression = false" >> $conf_file
        fi
        if [ $use_encryption == "1" ];then
            echo "use_encryption = true" >> $conf_file
        else
            echo "use_encryption = false" >> $conf_file
        fi
    done
    sed -i '/= $/d' $conf_file
  fi
}

start_frpc(){
    $KSROOT/frpc/frpc -c $conf_file &
}

stop_frpc(){
    for i in `ps|grep frpc|grep -v grep|grep -v config|awk -F' ' '{print $1}'`;do
        kill -9 $i >/dev/null 2>&1
    done
}

creat_start_up(){
	[ ! -L "/etc/rc.d/S95frpc.sh" ] && ln -sf /koolshare/init.d/S95frpc.sh /etc/rc.d/S95frpc.sh
}

del_start_up(){
	[ -L "/etc/rc.d/S95frpc.sh" ] && rm -rf /etc/rc.d/S95frpc.sh >/dev/null 2>&1
}


# used by rc.d
case $1 in
start)
	if [ "$frpc_enable" == "1" ];then
        write_conf
        stop_frpc
        start_frpc
        creat_start_up
	else
        stop_frpc
        del_start_up
    fi
	;;
stop)
    stop_frpc
    del_start_up
	;;
esac

# used by httpdb
case $2 in
start)
	if [ "$frpc_enable" == "1" ];then
        write_conf
        stop_frpc
        start_frpc
        creat_start_up
        http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'
	else
        stop_frpc
        del_start_up
        http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'
    fi
	;;
stop)
    stop_frpc
    del_start_up
    http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'
	;;
esac
