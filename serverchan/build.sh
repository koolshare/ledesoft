#!/bin/sh

MODULE=serverchan
VERSION=1.1.3
TITLE="Server酱"
DESCRIPTION="推送路由器信息到微信~"
HOME_URL=Module_serverchan.asp
CHANGELOG="修复流量不显示"

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
