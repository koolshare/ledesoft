#!/bin/sh

MODULE=dmz
VERSION=0.4
TITLE=DMZ
DESCRIPTION=将客户端完全暴露在公网
HOME_URL=Module_dmz.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
