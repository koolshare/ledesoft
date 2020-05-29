#!/bin/sh

MODULE=unifi
VERSION=1.1
TITLE="Unifi Controller"
DESCRIPTION=Debian系统和Unifi控制器
HOME_URL=Module_unifi.asp
CHANGELOG="修复key下载失效"

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
