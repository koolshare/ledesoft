#!/bin/sh

MODULE=syncthing
VERSION=1.8
TITLE=syncthing
DESCRIPTION=轻松搭建私有云
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

