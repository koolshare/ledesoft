#!/bin/sh

MODULE=cos
VERSION=0.5
TITLE=腾讯云存储
DESCRIPTION=软件中心自动云备份和恢复
HOME_URL=Module_cos.asp
CHANGELOG="支持2.30"

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
