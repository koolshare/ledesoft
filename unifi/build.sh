#!/bin/sh

MODULE=unifi
VERSION=1.0
TITLE="Unifi Controller"
DESCRIPTION=Debian系统和Unifi控制器
HOME_URL=Module_unifi.asp
CHANGELOG="安装目录自定义"

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
