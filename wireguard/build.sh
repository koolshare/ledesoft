#!/bin/sh

MODULE=wireguard
VERSION=0.2
TITLE="WireGuard"
DESCRIPTION="高效的次世代VPN"
HOME_URL=Module_wireguard.asp
CHANGELOG="修复nat转发规则未添加"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# build bin
sh $DIR/build/build $MODULE

# do something here

do_build_result

sh backup.sh $MODULE
