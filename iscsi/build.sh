#!/bin/sh

MODULE=iscsi
VERSION=0.5
TITLE=iSCSI服务器
DESCRIPTION=稳定高效的共享磁盘
HOME_URL=Module_iscsi.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# build bin
sh $DIR/build/build

# change to module directory
cd $DIR

# do something here
do_build_result

sh backup.sh $MODULE
