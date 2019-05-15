#!/bin/sh

MODULE=anyconnect
VERSION=0.9
TITLE="AnyConnect Server"
DESCRIPTION="与你的网络无缝并行"
HOME_URL=Module_anyconnect.asp
CHANGELOG="优化安装提示"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# build bin
sh $DIR/build/build anyconnect

# change to module directory
cd $DIR

# do something here
do_build_result

sh backup.sh $MODULE
