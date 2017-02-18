#!/bin/sh

export PERP_BASE=/jffs/koolshare/perp
export PATH=/jffs/koolshare/bin:/jffs/koolshare/scripts:/usr/bin:/sbin:/bin:/usr/sbin

ACTION=$1
ID=$1
LANIP=$(nvram get lan_ipaddr)
http_response()  {
        ARG0="$@"
        curl -X POST -d "$ARG0" http://$LANIP/_resp/$ID
}
