#!/bin/sh

MODULE=ikev1
VERSION=0.1
TITLE=IPsec服务器
DESCRIPTION=高安全的企业VPN服务器
HOME_URL=Module_ikev1.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# build bin
sh $DIR/build/build

# change to module directory
cd $DIR

# do something here
do_build_result

sh backup.sh $MODULE
