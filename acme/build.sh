#!/bin/sh

MODULE=acme
VERSION=0.5
TITLE="Let's Encrypt"
DESCRIPTION=自动部署SSL证书
HOME_URL=Module_acme.asp
CHANGELOG="修复ali，cloudxns接口"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# build bin
sh $DIR/build/build acme

# do something here

do_build_result

sh backup.sh $MODULE
