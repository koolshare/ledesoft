#!/bin/sh

MODULE="uuacc"
VERSION="0.1"
TITLE="UU游戏加速器"
DESCRIPTION="一键开启全球联机之旅"
HOME_URL="Module_uuacc.asp"
CHANGELOG="新增插件"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
