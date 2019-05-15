#!/bin/sh

MODULE="hotfix"
VERSION="0.2.5"
TITLE="HOTFIX"
DESCRIPTION="快速修复当前固件中的BUG"
HOME_URL="Module_hotfix.asp"
CHANGELOG="修复2.30 OPKG问题"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE

