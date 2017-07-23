#!/bin/sh

MODULE=ddnsto
VERSION=1.1
TITLE=DDNSTO
DESCRIPTION=支持http2协议的远程管理，仅支持远程管理路由器+NAS+Windows远程桌面
HOME_URL=Module_ddnsto.asp
#!/bin/sh
# Check and include base
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ "$MODULE" == "" ]; then
	echo "module not found"
	exit 1
fi

if [ -f "$DIR/$MODULE/$MODULE/install.sh" ]; then
	echo "install script not found"
	exit 2
fi

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
