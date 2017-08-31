#!/bin/sh

MODULE=usbmount
VERSION=1.0
TITLE=USB自动挂载
DESCRIPTION=将USB磁盘自动挂载到系统
HOME_URL=Module_usbmount.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
