#!/bin/sh

MODULE=n2n
VERSION=0.1
TITLE="N2N V2"
DESCRIPTION=开源的P2P加密组网
HOME_URL=Module_n2n.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# build bin
sh $DIR/build/build n2n

# change to module directory
cd $DIR

# do something here
do_build_result

sh backup.sh $MODULE
