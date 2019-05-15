#!/bin/sh

MODULE=routetable
VERSION=0.7
TITLE="路由表"
DESCRIPTION=系统路由表设置
HOME_URL=Module_routetable.asp
CHANGELOG="优化接口获取"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# build bin
sh $DIR/build/build $MODULE

# do something here

do_build_result

sh backup.sh $MODULE
