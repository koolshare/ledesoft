#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export frpc_`

conf_file="$KSROOT/frpc/frpc.ini"
version=`$KSROOT/frpc/frpc --version`
dbus set frpc_version=$version

write_conf(){
    echo "[common]" > $conf_file
    dbus list frpc|grep "frpc_common"|grep -v '=$'|grep -v 'srlist'|sed 's/=/ = /g'|sed "s/frpc_common_//g" >> $conf_file
    for i in `dbus get frpc_srlist|sed 's/>/\n/g'`;do
        echo "[`echo $i|cut -d'<' -f1`]" >> $conf_file
        echo "type = `echo $i|cut -d'<' -f2`" >> $conf_file
        echo "custom_domains = `echo $i|cut -d'<' -f3`" >> $conf_file
        echo "local_ip = `echo $i|cut -d'<' -f4`" >> $conf_file
        echo "local_port = `echo $i|cut -d'<' -f5`" >> $conf_file
        echo "remote_port = `echo $i|cut -d'<' -f6`" >> $conf_file
        use_gzip=`echo $i|cut -d'<' -f7`
        use_encryption=`echo $i|cut -d'<' -f8`
        privilege_mode=`echo $i|cut -d'<' -f9`
        if [ $use_gzip == "开启" ];then
            echo "use_gzip = true" >> $conf_file
        else
            echo "use_gzip = false" >> $conf_file
        fi
        if [ $use_encryption == "开启" ];then
            echo "use_encryption = true" >> $conf_file
        else
            echo "use_encryption = false" >> $conf_file
        fi
        if [ $privilege_mode == "开启" ];then
            echo "privilege_mode = true" >> $conf_file
        else
            echo "privilege_mode = false" >> $conf_file
        fi
    done
    sed -i '/= $/d' $conf_file

}

start_frpc(){
    $KSROOT/frpc/frpc -c $conf_file &
    sleep 1
    if [ "`ps|grep frpc|grep -v grep|grep -v /bin/sh|wc -l`" != "0" ];then
        dbus set frpc_last_act='<font color=green>服务已开启</font>'
        logger '[syncthing]:frpc is started!'
        /bin/sh $KSROOT/scripts/frpc_check.sh&
    else
        dbus set frpc_last_act='<font color=red>服务无法启动，请检查配置是否正确</font>'
        dbus set frpc_enable=0
        logger 'ERROR:[syncthing]:frpc is not started!'
    fi
}

stop_frpc(){
    for i in `ps|grep frpc|grep -v grep|grep -v config|awk -F' ' '{print $1}'`;do
        kill $i
    done
    dbus set frpc_last_act='<font color=red>服务已关闭</font>'
    logger '[syncthing]:frpc is stoped!'
}

auto_start(){
    if [ -L "$KSROOT/init.d/S96frpc.sh" ]; then
            rm -rf $KSROOT/init.d/S96frpc.sh
    fi
    if [ `dbus get frpc_enable` == 1 ];then
            ln -sf $KSROOT/scripts/frpc_check.sh $KSROOT/init.d/S96frpc.sh
    fi
}

case $ACTION in
start)
	start_frpc
	;;
stop)
	stop_frpc
	;;
*)
	if [ $frpc_enable == 1 ];then
        write_conf
        stop_frpc
        start_frpc
        auto_start
        http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'
	else
        stop_frpc
        auto_start
        http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'
    fi
    ;;
esac
