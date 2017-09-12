#!/bin/sh

MODULE=udpspeeder
VERSION=1.0.5
TITLE=UDPspeeder
DESCRIPTION=UDP双边加速工具
HOME_URL=Module_udpspeeder.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
