#!/bin/sh

MODULE=relay
VERSION=0.1
TITLE="瑞士军刀"
DESCRIPTION="端口映射、中转流量"
HOME_URL=Module_relay.asp
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
