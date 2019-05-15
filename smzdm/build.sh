#!/bin/sh

MODULE=smzdm
VERSION=0.1
TITLE="什么值得买"
DESCRIPTION=每日批量自动签到
HOME_URL=Module_smzdm.asp
CHANGELOG=""

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# build bin
sh $DIR/build/build smzdm

# do something here

do_build_result

sh backup.sh $MODULE
