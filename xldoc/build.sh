#!/bin/sh

MODULE=xldoc
VERSION=0.2
TITLE=救救迅雷
DESCRIPTION=修复迅雷不能下载的BUG
HOME_URL=Module_xldoc.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
