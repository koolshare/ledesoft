#!/bin/sh

MODULE=syncthing
VERSION=1.5
TITLE=syncthing
DESCRIPTION=多终端同步工具
HOME_URL=Module_syncthing.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE

