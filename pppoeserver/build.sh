#!/bin/sh

MODULE=pppoeserver
VERSION=0.1
TITLE="PPPoE Server"
DESCRIPTION=PPPOE服务器
HOME_URL=Module_pppoeserver.asp
CHANGELOG=""

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# build bin
sh $DIR/build/build pppoeserver

# do something here

do_build_result

sh backup.sh $MODULE
