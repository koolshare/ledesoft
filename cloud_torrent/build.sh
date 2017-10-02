#!/bin/sh

MODULE=cloud_torrent
VERSION=1.6
TITLE="cloud torrent"
DESCRIPTION="小巧便携BT下载器"
HOME_URL=Module_cloud_torrent.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
