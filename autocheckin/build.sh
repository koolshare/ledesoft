#!/bin/sh

MODULE=autocheckin
VERSION="0.3.1"
TITLE="签到狗2.0"
DESCRIPTION=每日批量自动签到
HOME_URL=Module_autocheckin.asp
CHANGELOG="修复BUG和增加签到站点"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# build bin
sh $DIR/build/build autocheckin

# do something here

do_build_result

sh backup.sh $MODULE
