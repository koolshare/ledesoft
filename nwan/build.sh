#!/bin/sh

MODULE=nwan
VERSION=0.1
TITLE="多线多拨"
DESCRIPTION=宽带并发多拨
HOME_URL=Module_nwan.asp
CHANGELOG=""

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# build bin
sh $DIR/build/build nwan

# do something here

do_build_result

sh backup.sh $MODULE
