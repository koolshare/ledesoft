#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

eval `dbus export dnspod_`

a_name=`echo $dnspod_domain | cut -d \. -f 1`
a_domain=`echo $dnspod_domain | cut -d \. -f 2`.`echo $dnspod_domain | cut -d \. -f 3`

if [ "$dnspod_enable" != "1" ]; then
    echo "not enable"
    exit
fi

now=`date "+%Y-%m-%d %H:%M:%S"`

die () {
    echo $1
    dbus set dnspod_last_act="$now [失败](IP:$1)"
}

[ "$dnspod_curl" = "" ] && dnspod_curl="1"
[ "$dnspod_dns" = "" ] && dnspod_dns="223.5.5.5"
#[ "$dnspod_ttl" = "" ] && dnspod_ttl="600"
case $dnspod_curl in
"1")
    ip=`curl -s whatismyip.akamai.com 2>&1` || die "$ip"
    ;;
"2")
    ip=$(ubus call network.interface.wan status | grep \"address\" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
    ;;
"3")
    ip=$(ubus call network.interface.wan3 status | grep \"address\" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
    ;;
"4")
    ip=$(ubus call network.interface.wan4 status | grep \"address\" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
    ;;
"5")
    ip=$(ubus call network.interface.wan status | grep \"address\" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
    ;; 
*)
    ip=`curl -s http://ip.chinaz.com/getip.aspx|cut -d"'" -f2` || die "$ip"
    ;;
esac
#ip=`$dnspod_curl 2>&1` || die "$ip"

#support @ record nslookup
if [ "$a_name" = "@" ]
then
  current_ip=`nslookup $a_domain $dnspod_dns 2>&1`
else
  current_ip=`nslookup $dnspod_domain $dnspod_dns 2>&1`
fi

if [ "$?" -eq "0" ]
then
    current_ip=`echo "$current_ip" | grep 'Address 1' | tail -n1 | awk '{print $NF}'`

    if [ "$ip" = "$current_ip" ]
    then
        echo "skipping"
        dbus set dnspod_last_act="<font color=blue>$now    域名解析正常，跳过更新 当前IP：$ip</font>"
        exit 0
    fi 
# fix when A record removed by manual dns is always update error
else
    unset dnspod_record_id
fi


timestamp=`date -u "+%Y-%m-%dT%H%%3A%M%%3A%SZ"`

urlencode() {
    # urlencode <string>
    out=""
    while read -n1 c
    do
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

send_request() {
    local args="login_token=$dnspod_ak,$dnspod_sk&Format=json&$2"
    #echo $1$args>>/jffs/koolshare/dnspod.txt
    #local hash=$(echo -n "GET&%2F&$(enc "$args")" | openssl dgst -sha1 -hmac "$dnspod_sk&" -binary | openssl base64)
    $KSROOT/bin/wget --no-check-certificate --post-data "$args" "https://dnsapi.cn/$1" -O /tmp/ddnspod
    #curl -d "$args" "https://dnsapi.cn/$1"
    #&Signature=$(enc "$hash")"
}

get_recordid() {
   egrep -C8 "<name>$a_name1</name>"|grep "<id>"|awk -F'>' '{print $2}'|awk -F'<' '{print $1}'
}

get_recordid2() {
   grep 'id'|awk -F'>' '{print $2}'|awk -F'<' '{print $1}' 
}

query_recordid() {
    send_request "Record.List" "domain=$a_domain"
}

update_record() {
    send_request "Record.Ddns" "domain=$a_domain&record_id=$1&record_line=默认&sub_domain=$a_name1&value=$ip"
}

add_record() {
    send_request "Record.Create" "domain=$a_domain&sub_domain=$a_name1&record_type=A&record_line=默认&value=$ip"
}

#add support */%2A and @/%40 record
case  $a_name  in
      \*)
        a_name1=%2A
        ;;
      \@)
        a_name1=%40
        ;;
      *)
        a_name1=$a_name
        ;;
esac

if [ "$dnspod_record_id" = "" ]
then
    query_recordid
    dnspod_record_id=`cat /tmp/ddnspod | get_recordid`
fi
if [ "$dnspod_record_id" = "" ]
then
    add_record
    dnspod_record_id=`cat /tmp/ddnspod | get_recordid2`
    echo "added record $dnspod_record_id"
else
    update_record $dnspod_record_id
    echo "updated record $dnspod_record_id"
fi

# save to file
if [ "$dnspod_record_id" = "" ]; then
    # failed
    logger "[Dnspod]:$now failed"
    dbus set dnspod_last_act="<font color=red>$now    域名解析失败</font>"
else
    dbus set dnspod_last_act="<font color=green>$now    域名解析成功。当前IP：$ip</font>"
    logger "[Dnspod]:$now $ip succeed"
fi