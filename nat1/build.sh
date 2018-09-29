#!/bin/sh

MODULE=nat1
VERSION=0.2
TITLE="Full cone NAT"
DESCRIPTION="NAT类型-Full cone"
HOME_URL=Module_nat1.asp
CHANGELOG=""

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# build bin
sh $DIR/build/build nat1

# change to module directory
cd $DIR

# do something here
do_build_result

sh backup.sh $MODULE
