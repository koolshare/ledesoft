#!/bin/sh

MODULE=virtual
VERSION=0.1
TITLE="虚拟机助手"
DESCRIPTION=增强虚拟机操作系统性能
HOME_URL=Module_virtual.asp
CHANGELOG=""

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# build bin
sh $DIR/build/build virtual

# change to module directory
cd $DIR

# do something here
do_build_result

sh backup.sh $MODULE
