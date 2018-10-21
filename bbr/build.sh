#!/bin/sh

MODULE=bbr
VERSION=0.2
TITLE="BBR MOD"
DESCRIPTION=魔改BBR
HOME_URL=Module_bbr.asp
CHANGELOG="增加更多模块"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# build bin
sh $DIR/build/build bbr

# change to module directory
cd $DIR

# do something here
do_build_result

sh backup.sh $MODULE
