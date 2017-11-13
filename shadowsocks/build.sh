#!/bin/sh

MODULE=shadowsocks
VERSION=`cat shadowsocks/ss/version`
TITLE=shadowsocks
DESCRIPTION="轻松科学上网~"
HOME_URL=Module_shadowsocks.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result

sh backup.sh $MODULE



