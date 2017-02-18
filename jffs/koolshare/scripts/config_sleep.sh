#!/bin/sh

#TODO better
export PERP_BASE=/jffs/koolshare/perp
export PATH=/jffs/koolshare/bin:/jffs/koolshare/scripts:/usr/bin:/sbin:/bin:/usr/sbin

ACTION=$1
ID=$1
IP=127.0.0.1:80

http_response()  {
        ARG0="$@"
        curl -X POST -d "$ARG0" http://$IP/_resp/$ID
}

echo "test only"
sleep 30
http_response "postend"
