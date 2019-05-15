#!/bin/sh

MODULE=sgame
VERSION=0.8.8
TITLE="游戏加速器"
DESCRIPTION="外服游戏解决方案"
HOME_URL=Module_sgame.asp
CHANGELOG="修复mac控制"

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
