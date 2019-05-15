#!/bin/sh

MODULE="ddnsto"
VERSION="2.0"
TITLE="DDNSTO 远程穿透"
DESCRIPTION="支持http2协议的远程管理，仅支持远程管理路由器+NAS+Windows远程桌面"
HOME_URL="Module_ddnsto.asp"
CHANGELOG="更新验证方式"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
