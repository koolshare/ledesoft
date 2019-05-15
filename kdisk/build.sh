#!/bin/sh

MODULE=kdisk
VERSION=0.2
TITLE=硬盘助手
DESCRIPTION=安装盘剩余空间挂载
HOME_URL=Module_kdisk.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# build bin
sh $DIR/build/build kdisk

# change to module directory
cd $DIR

# do something here
do_build_result

sh backup.sh $MODULE
