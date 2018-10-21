#!/bin/sh

MODULE=serverchan
VERSION=1.1.6
TITLE="Server酱"
DESCRIPTION="推送路由器信息到微信~"
HOME_URL=Module_serverchan.asp
CHANGELOG="修复新固件下客户端上线通知失效"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result

# now make backup
sh backup.sh $MODULE
