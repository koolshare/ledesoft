#!/bin/sh

MODULE=ftp
VERSION=1.0.4
TITLE=FTP服务器
DESCRIPTION=小巧安全的FTP服务器
HOME_URL=Module_ftp.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
