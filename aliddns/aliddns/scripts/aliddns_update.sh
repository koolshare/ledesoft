#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

eval `dbus export aliddns_`

a_name=`echo $aliddns_domain | cut -d \. -f 1`
a_domain=`echo $aliddns_domain | cut -d \. -f 2`.`echo $aliddns_domain | cut -d \. -f 3`

if [ "$aliddns_enable" != "1" ]; then
    echo "not enable"
    exit
fi

now=`date "+%Y-%m-%d %H:%M:%S"`

die () {
    echo $1
    dbus ram aliddns_last_act="$now [失败](IP:$1)"
}

[ "$aliddns_curl" = "" ] && aliddns_curl="curl -s whatismyip.akamai.com"
[ "$aliddns_dns" = "" ] && aliddns_dns="223.5.5.5"
[ "$aliddns_ttl" = "" ] && aliddns_ttl="600"

ip=`$aliddns_curl 2>&1` || die "$ip"

#support @ record nslookup
if [ "$a_name" = "@" ]
then
  current_ip=`nslookup $a_domain $aliddns_dns 2>&1`
else
  current_ip=`nslookup $aliddns_domain $aliddns_dns 2>&1`
fi

if [ "$?" -eq "0" ]
then
    current_ip=`echo "$current_ip" | grep 'Address 1' | tail -n1 | awk '{print $3}'`

    if [ "$ip" = "$current_ip" ]
    then
        echo "skipping"
        dbus set aliddns_last_act="<font color=blue>$now    域名解析正常，跳过更新</font>"
        exit 0
    fi 
# fix when A record removed by manual dns is always update error
else
    unset aliddns_record_id
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
    local args="AccessKeyId=$aliddns_ak&Action=$1&Format=json&$2&Version=2015-01-09"
    local hash=$(echo -n "GET&%2F&$(enc "$args")" | openssl dgst -sha1 -hmac "$aliddns_sk&" -binary | openssl base64)
    curl -s "http://alidns.aliyuncs.com/?$args&Signature=$(enc "$hash")"
}

get_recordid() {
    grep -Eo '"RecordId":"[0-9]+"' | cut -d':' -f2 | tr -d '"'
}

query_recordid() {
    send_request "DescribeSubDomainRecords" "SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&SubDomain=$a_name1.$a_domain&Timestamp=$timestamp"
}

update_record() {
    send_request "UpdateDomainRecord" "RR=$a_name1&RecordId=$1&SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&TTL=$aliddns_ttl&Timestamp=$timestamp&Type=A&Value=$ip"
}

add_record() {
    send_request "AddDomainRecord&DomainName=$a_domain" "RR=$a_name1&SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&TTL=$aliddns_ttl&Timestamp=$timestamp&Type=A&Value=$ip"
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

if [ "$aliddns_record_id" = "" ]
then
    aliddns_record_id=`query_recordid | get_recordid`
fi
if [ "$aliddns_record_id" = "" ]
then
    aliddns_record_id=`add_record | get_recordid`
    echo "added record $aliddns_record_id"
else
    update_record $aliddns_record_id
    echo "updated record $aliddns_record_id"
fi

# save to file
if [ "$aliddns_record_id" = "" ]; then
    # failed
    dbus ram aliddns_last_act="<font color=red>$now    域名解析失败</font>"
else
    dbus ram aliddns_last_act="<font color=green>$now    域名解析成功。当前IP：$ip</font>"
fi
