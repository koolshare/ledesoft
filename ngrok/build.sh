#!/bin/sh

MODULE=ngrok
VERSION=1.0
TITLE=ngrok
DESCRIPTION=NGROK内网穿透工具
HOME_URL=Module_ngrok.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
