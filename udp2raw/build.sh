#!/bin/sh

MODULE=udp2raw
VERSION=0.3
TITLE=udp2raw
DESCRIPTION="应对udp限速、屏蔽"
HOME_URL=Module_udp2raw.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
