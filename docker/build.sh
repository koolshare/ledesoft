#!/bin/sh

MODULE=docker
VERSION=0.2.3
TITLE="Docker"
DESCRIPTION="轻量虚拟化应用程序"
HOME_URL=Module_docker.asp
CHANGELOG="修复创建容器的错误"

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
