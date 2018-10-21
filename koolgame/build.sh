#!/bin/sh

MODULE="koolgame"
VERSION="1.0.8"
TITLE="koolgame 游戏加速"
DESCRIPTION="小宝开发的游戏加速V2"
HOME_URL="Module_koolgame.asp"
CHANGELOG="修复BUG"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
