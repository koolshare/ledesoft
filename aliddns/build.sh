#!/bin/sh

MODULE=aliddns
VERSION=0.4
TITLE=AliDDNS
DESCRIPTION=阿里云解析自动更新IP
HOME_URL=Module_aliddns.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
