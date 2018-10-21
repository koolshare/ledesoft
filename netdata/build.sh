#!/bin/sh

MODULE=netdata
VERSION=0.1
TITLE=路由监控
DESCRIPTION=仪表式查看路由详细状态
HOME_URL=Module_netdata.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# build bin
sh $DIR/build/build $MODULE

# change to module directory
cd $DIR

# do something here
do_build_result

sh backup.sh $MODULE
