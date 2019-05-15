#!/bin/sh

MODULE=koolddns
VERSION=0.6.1
TITLE="Koolddns"
DESCRIPTION=动态域名解析工具
HOME_URL=Module_koolddns.asp
CHANGELOG="修复导致ui错位的bug"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# build bin
sh $DIR/build/build koolddns

# do something here

do_build_result

sh backup.sh $MODULE
