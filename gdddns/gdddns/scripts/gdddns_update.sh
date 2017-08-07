#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export gdddns_`

if [ "$gdddns_enable" != "1" ]; then
    echo "not enable"
    exit
fi

now=`date "+%Y-%m-%d %H:%M:%S"`

g_name="home"
g_domain="example.com"
domain_test=`echo $gdddns_domain | cut -d \. -f 3`

if [ -n "$domain_test" ]; then
    g_name=`echo $gdddns_domain | cut -d \. -f 1`
    g_domain=`echo $gdddns_domain | cut -d \. -f 2`.`echo $gdddns_domain | cut -d \. -f 3`
else
    g_name="@"
    g_domain="$gdddns_domain"
fi

case $gdddns_curl in
"2")
    ip=$(ubus call network.interface.wan2 status | grep \"address\" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
    ;;
"3")
    ip=$(ubus call network.interface.wan3 status | grep \"address\" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
    ;;
"4")
    ip=$(ubus call network.interface.wan4 status | grep \"address\" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
    ;;
*)
    ip=$(ubus call network.interface.wan status | grep \"address\" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
    ;;
esac

current_ip_info=`nslookup $gdddns_domain $gdddns_dns 2>&1`

[ "$gdddns_curl" = "" ] && gdddns_curl="1"
[ "$gdddns_dns" = "" ] && gdddns_dns="114.114.114.114"
[ "$gdddns_ttl" = "" ] && gdddns_ttl="600"


die () {
    echo $1
    dbus set gdddns_last_act="$now [失败](IP:$1)"
}

urlencode() {
    # urlencode <string>
    out=""
    while read -n1 c; do
        case $c in
            [a-zA-Z0-9._-]) out="$out$c" ;;
            *) out="$out`printf '%%%02X' "'$c"`" ;;
        esac
    done
    echo -n $out
}

enc() {
    echo -n "$1" | urlencode
}

update_record() {
    curl -kLsX PUT -H "Authorization: sso-key $gdddns_key:$gdddns_secret" \
        -H "Content-type: application/json" "https://api.godaddy.com/v1/domains/$g_domain/records/A/$(enc "$g_name")" \
        -d "{\"data\":\"$ip\",\"ttl\":$gdddns_ttl}"
}


if [ "$?" -eq "0" ]; then
    current_ip=`echo "$current_ip_info" | grep 'Address 1' | tail -n1 | awk '{print $NF}'`

    if [ "$ip" = "$current_ip" ]; then
        echo "skipping..."
        dbus set gdddns_last_act="<font color=blue>$now    域名解析正常，跳过更新</font>"
        exit 0
    else
        echo "changing..."
        update_record
        if [ "$?" -eq "0" ]; then
            dbus set gdddns_last_act="<font color=blue>$now    解析已更新，当前解析IP: $ip</font>"
        else
            dbus set gdddns_last_act="<font color=red>$now    解析更新失败！</font>"
        fi
    fi 
else
    dbus set gdddns_last_act="<font color=red>$now    域名解析失败！</font>"
fi

