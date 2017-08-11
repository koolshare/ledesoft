#!/bin/sh

MODULE=kms
VERSION=0.4
TITLE=kms
DESCRIPTION=巨硬套餐激活工具
HOME_URL=Module_kms.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE

