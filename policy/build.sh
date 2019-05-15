#!/bin/sh

MODULE=policy
VERSION=0.7
TITLE="策略路由"
DESCRIPTION=多运营商自动分流
HOME_URL=Module_policy.asp
CHANGELOG="增加客户端分流"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# build bin
sh $DIR/build/build policy

# do something here

do_build_result

sh backup.sh $MODULE
