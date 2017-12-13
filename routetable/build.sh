#!/bin/sh

MODULE=routetable
VERSION=0.1
TITLE="路由表设置"
DESCRIPTION=路由流量指明灯
HOME_URL=Module_routetable.asp
CHANGELOG=""

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# build bin
sh $DIR/build/build routetable

# do something here

do_build_result

sh backup.sh $MODULE
