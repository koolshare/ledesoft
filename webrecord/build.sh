#!/bin/sh

MODULE=webrecord
VERSION=0.1
TITLE="上网记录"
DESCRIPTION=查看网址和搜索记录
HOME_URL=Module_webrecord.asp
CHANGELOG=""

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
