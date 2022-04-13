#!/bin/sh

MODULE=lnmp
VERSION=0.7
TITLE=LNMP
DESCRIPTION=自动化部署WEB环境
HOME_URL=Module_lnmp.asp
CHANGELOG="修复一些bug"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# build bin
sh $DIR/build/build lnmp

# change to module directory
cd $DIR

# do something here
do_build_result

sh backup.sh $MODULE
