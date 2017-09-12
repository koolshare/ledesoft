#!/bin/sh

MODULE=shadowsocks
VERSION=`cat shadowsocks/ss/version`
TITLE=shadowsocks
DESCRIPTION="轻松科学上网~"
HOME_URL=Module_shadowsocks.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result

sh backup.sh $MODULE


# ----------------------------------------------------
MD5=`cat config.json.js |grep md5 |awk -F "\"" '{print $4}'`
cat > config.json.js <<-EOF
[
	{
	    "build_date": "2017-09-09_18:29:47", 
	    "description": "轻松科学上网~", 
	    "home_url": "Module_shadowsocks.asp", 
	    "md5": "$MD5", 
	    "name": "shadowsocks", 
	    "tar_url": "shadowsocks/shadowsocks.tar.gz", 
	    "title": "shadowsocks", 
	    "version": "$VERSION"
	}
]
EOF
# ----------------------------------------------------

