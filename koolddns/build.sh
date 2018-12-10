#!/bin/sh

MODULE=koolddns
VERSION=0.2.1
TITLE="Koolddns"
DESCRIPTION=动态域名解析工具
HOME_URL=Module_koolddns.asp
CHANGELOG="增加Secret/Token填写位数"

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
