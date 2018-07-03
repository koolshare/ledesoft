#!/bin/sh

MODULE=fwupdate
VERSION=0.2.7
TITLE=固件更新
DESCRIPTION=在线更新路由器固件
HOME_URL=Module_fwupdate.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
