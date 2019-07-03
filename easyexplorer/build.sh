#!/bin/sh

MODULE="easyexplorer"
VERSION="1.6"
TITLE="易有云 - EasyExplorer"
DESCRIPTION="强大易用的全平台同步工具,支持双向同步！"
HOME_URL="Module_easyexplorer.asp"
CHANGELOG="优化插件"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
