#!/bin/sh

MODULE=brook
VERSION=0.3
TITLE="Brook"
DESCRIPTION="跨平台的Socks5代理"
HOME_URL=Module_brook.asp
CHANGELOG="升级二进制"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# build bin
sh $DIR/build/build brook

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
