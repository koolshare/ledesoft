#!/bin/sh

MODULE=homebridge
VERSION=0.7
TITLE=Homebridge
DESCRIPTION=智能家庭网关
HOME_URL=Module_homebridge.asp
CHANGELOG="修复安装包下载"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# build bin
sh $DIR/build/build

# do something here

do_build_result

sh backup.sh $MODULE
