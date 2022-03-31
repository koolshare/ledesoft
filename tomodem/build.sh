#!/bin/sh

MODULE=tomodem
VERSION=0.1
TITLE="光猫助手"
DESCRIPTION=路由拨号后也能设置光猫
HOME_URL=Module_tomodem.asp
CHANGELOG=""

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# build bin
sh $DIR/build/build tomodem

# change to module directory
cd $DIR

# do something here
do_build_result

sh backup.sh $MODULE
