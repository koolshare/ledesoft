#!/bin/sh

MODULE=gdddns
VERSION=1.2
TITLE=gdddns
DESCRIPTION=Godaddy-DDNS
HOME_URL=Module_gdddns.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
