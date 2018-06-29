#!/bin/sh

MODULE=fastdick
VERSION=0.9
TITLE=迅雷快鸟
DESCRIPTION=宽带上下行提速
HOME_URL=Module_fastdick.asp
CHANGELOG="增加断线重拨自动重置"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# build bin
sh $DIR/build/build fastdick

# change to module directory
cd $DIR

# do something here
do_build_result

sh backup.sh $MODULE
