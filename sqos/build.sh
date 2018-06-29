#!/bin/sh

MODULE=sqos
VERSION=0.1
TITLE="QOS"
DESCRIPTION="宽带限速、优化"
HOME_URL=Module_sqos.asp
CHANGELOG=""

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# build bin
sh $DIR/build/build sqos

# do something here

do_build_result

sh backup.sh $MODULE
