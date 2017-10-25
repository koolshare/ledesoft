#!/bin/sh

MODULE=anyconnect
VERSION=0.1
TITLE="AnyConnect Server"
DESCRIPTION="方便在任何设备上安全地办公"
HOME_URL=Module_anyconnect.asp
CHANGELOG=""

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# build bin
sh $DIR/build/build anyconnect

# change to module directory
cd $DIR

# do something here
do_build_result

sh backup.sh $MODULE
