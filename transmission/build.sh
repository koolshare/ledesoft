#!/bin/sh

MODULE=transmission
VERSION=0.1
TITLE=Transmission
DESCRIPTION="高效的BT、PT下载工具"
HOME_URL=Module_transmission.asp
CHANGELOG=""

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# build bin
sh $DIR/build/build transmission

# change to module directory
cd $DIR

# do something here
do_build_result

sh backup.sh $MODULE
