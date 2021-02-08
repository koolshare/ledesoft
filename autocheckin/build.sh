#!/bin/sh

MODULE="autocheckin"
VERSION="2.0"
TITLE="签到狗3.0"
DESCRIPTION="每日批量自动签到"
HOME_URL="Module_autocheckin.asp"
CHANGELOG="修正更新"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
