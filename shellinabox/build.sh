#!/bin/sh


MODULE=shellinabox
VERSION=1.1.5
TITLE=ShellnaBox
DESCRIPTION=超强的SSH网页客户端
HOME_URL=Module_shellinabox.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
