#!/bin/sh

MODULE=koolproxy
VERSION=3.6.1.20
TITLE=koolproxy
DESCRIPTION=听说KP和软路由更搭哦~
HOME_URL=Module_koolproxy.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
