#!/bin/sh

MODULE=webd
VERSION=0.1
TITLE="我的网盘"
DESCRIPTION="小巧便携的网盘"
HOME_URL=Module_webd.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
