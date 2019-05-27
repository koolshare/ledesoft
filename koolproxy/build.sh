#!/bin/sh

MODULE="koolproxy"
VERSION="3.8.5.6"
TITLE=koolproxy
DESCRIPTION="听说KP和软路由更搭哦~"
HOME_URL="Module_koolproxy.asp"
CHANGELOG="有缘再见"

#get latest rules
#cd koolproxy/koolproxy/data/rules
#rm -rf *
#wget https://kprule.com/koolproxy.txt
#wget https://kprule.com/daily.txt
#wget https://kprule.com/kp.dat
#wget https://kprule.com/user.txt
#cd ../../../..

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
